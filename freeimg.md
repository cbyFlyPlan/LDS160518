# FreeImage.dll 使用

## 一、使用步骤

### FreeImage API 分类详细列表
>1. 初始化和清理
    FreeImage_Initialise(bool loadLocalPluginsOnly): 初始化 FreeImage 库。
    FreeImage_DeInitialise(): 取消初始化 FreeImage 库。

>2. 图像加载与保存
    IntPtr FreeImage_Load(int fif, string filename, int flags): 从文件加载图像。
    IntPtr FreeImage_LoadFromMemory(IntPtr fif, IntPtr stream, int flags): 从内存流加载图像。
    bool FreeImage_Save(int fif, IntPtr dib, string filename, int flags): 将图像保存到文件。
    IntPtr FreeImage_SaveToMemory(IntPtr fif, IntPtr dib, IntPtr stream, int flags): 将图像保存到内存流。

>3. 图像处理
    IntPtr FreeImage_ConvertTo24Bits(IntPtr dib): 将图像转换为 24 位 RGB 图像。
    IntPtr FreeImage_ConvertToGreyscale(IntPtr dib): 将图像转换为灰度图像。
    IntPtr FreeImage_Resize(IntPtr dib, int width, int height, int filter): 调整图像大小。
    IntPtr FreeImage_Rotate(IntPtr dib, double angle, IntPtr bkcolor): 旋转图像。

>4. 元数据访问
    int FreeImage_GetWidth(IntPtr dib): 获取图像宽度。
    int FreeImage_GetHeight(IntPtr dib): 获取图像高度。
    int FreeImage_GetBPP(IntPtr dib): 获取图像每像素位数。
    int FreeImage_GetFileType(string filename, int size): 获取图像文件类型。
    int FreeImage_GetFIFFromFilename(string filename): 从文件名获取图像文件类型。

>5. 内存管理
    IntPtr FreeImage_OpenMemory(byte[] data, uint size): 打开一个内存流。
    void FreeImage_CloseMemory(IntPtr stream): 关闭一个内存流。
    void FreeImage_Unload(IntPtr dib): 卸载图像。
 

 
 