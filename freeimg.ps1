# 检查 FreeImage 类型是否已经存在
if ([System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetTypes() | Where-Object { $_.Name -eq 'FreeImageWrapper' } }) {
    # Write-Host "FreeImage type already exists. Restarting PowerShell session..."
    # Start-Process powershell -ArgumentList "-NoExit", "-File `"$PSCommandPath`""
    # exit
}else{

    # 定义和加载 FreeImage.dll 的函数
$source = @"
using System;
using System.Runtime.InteropServices;

public class FreeImageWrapper
{
    [DllImport(@"$freeImageDllPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern void FreeImage_Initialise(bool loadLocalPluginsOnly);

    [DllImport(@"$freeImageDllPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern void FreeImage_DeInitialise();

    [DllImport(@"$freeImageDllPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr FreeImage_Load(int fif, string filename, int flags);

    [DllImport(@"$freeImageDllPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern bool FreeImage_Save(int fif, IntPtr dib, string filename, int flags);

    [DllImport(@"$freeImageDllPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern void FreeImage_Unload(IntPtr dib);

    [DllImport(@"$freeImageDllPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern void FreeImage_SetOutputMessage(IntPtr error_handler);

    [DllImport(@"$freeImageDllPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr FreeImage_ConvertTo24Bits(IntPtr dib);

    [DllImport(@"$freeImageDllPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern int FreeImage_GetFileType(string filename, int size);

    [DllImport(@"$freeImageDllPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern int FreeImage_GetFIFFromFilename(string filename);

    // 错误回调函数类型
    public delegate void FreeImageErrorHandler(FREE_IMAGE_FORMAT fif, string message);

    public enum FREE_IMAGE_FORMAT
    {
        FIF_UNKNOWN = -1,
        FIF_BMP = 0,
        FIF_ICO = 1,
        FIF_JPEG = 2,
        FIF_JNG = 3,
        FIF_KOALA = 4,
        FIF_LBM = 5,
        FIF_IFF = FIF_LBM,
        FIF_MNG = 6,
        FIF_PBM = 7,
        FIF_PBMRAW = 8,
        FIF_PCD = 9,
        FIF_PCX = 10,
        FIF_PGM = 11,
        FIF_PGMRAW = 12,
        FIF_PNG = 13,
        FIF_PPM = 14,
        FIF_PPMRAW = 15,
        FIF_RAS = 16,
        FIF_TARGA = 17,
        FIF_TIFF = 18,
        FIF_WBMP = 19,
        FIF_PSD = 20,
        FIF_CUT = 21,
        FIF_XBM = 22,
        FIF_XPM = 23,
        FIF_DDS = 24,
        FIF_GIF = 25,
        FIF_HDR = 26,
        FIF_FAXG3 = 27,
        FIF_SGI = 28,
        FIF_EXR = 29,
        FIF_J2K = 30,
        FIF_JP2 = 31,
        FIF_PFM = 32,
        FIF_PICT = 33,
        FIF_RAW = 34
    }
}
"@

# 使用 Add-Type cmdlet 将 C# 代码添加到 PowerShell 会话中
Add-Type -TypeDefinition $source
}

# 确定 PowerShell 进程的位数
if ([Environment]::Is64BitProcess) {
    $freeImageDllPath = "D:\cby\code\vscode\md\FreeImage.dll" # 64 位版本
} else {
    $freeImageDllPath = "D:\cby\code\vscode\md\FreeImage.dll" # 32 位版本
}



# 错误处理回调函数
$global:freeImageErrorMessage = ""

$callback = {
    param (
        [FreeImageWrapper+FREE_IMAGE_FORMAT] $fif,
        [string] $message
    )
    $global:freeImageErrorMessage = $message
}

# 将回调函数指针传递给 FreeImage
$delegate = [FreeImageWrapper+FreeImageErrorHandler] $callback
$callbackPointer = [Runtime.InteropServices.Marshal]::GetFunctionPointerForDelegate($delegate)

# 设置错误回调函数
[FreeImageWrapper]::FreeImage_SetOutputMessage($callbackPointer)

# 调用 FreeImage 函数进行初始化
Write-Host "Initializing FreeImage..."
[FreeImageWrapper]::FreeImage_Initialise($false)

# 获取命令行参数
if ($args.Count -lt 3) {
    Write-Host "Usage: .\convert_image.ps1 <InputFile> <OutputFile> <OutputFormat>"
    [FreeImageWrapper]::FreeImage_DeInitialise()
    exit
}

$inputFile = $args[0]
$outputFile = $args[1]
$outputFormat = $args[2]

# 调试输出，检查参数是否正确接收
Write-Host "Input File: $inputFile"
Write-Host "Output File: $outputFile"
Write-Host "Output Format: $outputFormat"

if (-not (Test-Path $inputFile)) {
    Write-Host "Input file not found: $inputFile"
    [FreeImageWrapper]::FreeImage_DeInitialise()
    exit
}

# 检测图像格式
Write-Host "Detecting image format..."
$format = [FreeImageWrapper]::FreeImage_GetFileType($inputFile, 0)
if ($format -eq [FreeImageWrapper+FREE_IMAGE_FORMAT]::FIF_UNKNOWN) {
    $format = [FreeImageWrapper]::FreeImage_GetFIFFromFilename($inputFile)
}

if ($format -eq [FreeImageWrapper+FREE_IMAGE_FORMAT]::FIF_UNKNOWN) {
    Write-Host "Failed to detect image format."
    [FreeImageWrapper]::FreeImage_DeInitialise()
    exit
} else {
    Write-Host "Image format detected: $format"
}

# 加载图像
Write-Host "Loading image..."
$image = [FreeImageWrapper]::FreeImage_Load($format, $inputFile, 0)

if ($image -eq [IntPtr]::Zero) {
    Write-Host "Failed to load image."
    [FreeImageWrapper]::FreeImage_DeInitialise()
    exit
} else {
    Write-Host "Image loaded successfully."
}

# 将图像转换为 24 位 RGB
Write-Host "Converting image to 24-bit RGB..."
$convertedImage = [FreeImageWrapper]::FreeImage_ConvertTo24Bits($image)

if ($convertedImage -eq [IntPtr]::Zero) {
    Write-Host "Failed to convert image."
    [FreeImageWrapper]::FreeImage_Unload($image)
    [FreeImageWrapper]::FreeImage_DeInitialise()
    exit
} else {
    Write-Host "Image converted successfully."
}

# 根据外部输入确定保存格式
switch ($outputFormat.ToLower()) {
    "jpeg" { $saveFormat = [FreeImageWrapper+FREE_IMAGE_FORMAT]::FIF_JPEG }
    "png" { $saveFormat = [FreeImageWrapper+FREE_IMAGE_FORMAT]::FIF_PNG }
    "bmp" { $saveFormat = [FreeImageWrapper+FREE_IMAGE_FORMAT]::FIF_BMP }
    "tiff" { $saveFormat = [FreeImageWrapper+FREE_IMAGE_FORMAT]::FIF_TIFF }
    default {
        Write-Host "Unsupported output format: $outputFormat"
        [FreeImageWrapper]::FreeImage_Unload($convertedImage)
        [FreeImageWrapper]::FreeImage_Unload($image)
        [FreeImageWrapper]::FreeImage_DeInitialise()
        exit
    }
}

# 保存图像
Write-Host "Saving image..."
$saved = [FreeImageWrapper]::FreeImage_Save($saveFormat, $convertedImage, $outputFile, 0)

if ($saved) {
    Write-Host "Image saved successfully."
} else {
    Write-Host "Failed to save image. Error message: $global:freeImageErrorMessage"
}

# 卸载图像
Write-Host "Unloading images..."
[FreeImageWrapper]::FreeImage_Unload($convertedImage)
[FreeImageWrapper]::FreeImage_Unload($image)

# 取消初始化 FreeImage
Write-Host "Deinitializing FreeImage..."
[FreeImageWrapper]::FreeImage_DeInitialise()
