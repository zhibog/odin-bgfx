package bgfx_bindings

import "core:c"

/**
 * Fatal error enum.
 *
 */
fatal_t :: enum c.int {
    DEBUG_CHECK              = 0,
    INVALID_SHADER           = 1,
    UNABLE_TO_INITIALIZE     = 1,
    UNABLE_TO_CREATE_TEXTURE = 3,
    DEVICE_LOST              = 4,
    COUNT                    = 5,
}

/**
 * Renderer backend type enum.
 *
 */
renderer_type_t :: enum c.int {
    NOOP       = 0,  /** ( 0) No rendering.                  */
    AGC        = 1,  /** ( 1) AGC                            */
    DIRECT3D9  = 2,  /** ( 2) Direct3D 9.0                   */
    DIRECT3D11 = 3,  /** ( 3) Direct3D 11.0                  */
    DIRECT3D12 = 4,  /** ( 4) Direct3D 12.0                  */
    GNM        = 5,  /** ( 5) GNM                            */
    METAL      = 6,  /** ( 6) Metal                          */
    NVN        = 7,  /** ( 7) NVN                            */
    OPENGLES   = 8,  /** ( 8) OpenGL ES 2.0+                 */
    OPENGL     = 9,  /** ( 9) OpenGL 2.1+                    */
    VULKAN     = 10, /** (10) Vulkan                         */
    WEBGPU     = 11, /** (11) WebGPU                         */
    COUNT      = 12,
}

/**
 * Access mode enum.
 *
 */
access_t :: enum c.int {
    READ      = 0, /** ( 0) Read.                          */
    WRITE     = 1, /** ( 1) Write.                         */
    READWRITE = 2, /** ( 2) Read and write.                */
    COUNT     = 3,
}

/**
 * Vertex attribute enum.
 *
 */
attrib_t :: enum c.int {
    POSITION  =  0, /** ( 0) a_position                     */
    NORMAL    =  1, /** ( 1) a_normal                       */
    TANGENT   =  2, /** ( 2) a_tangent                      */
    BITANGENT =  3, /** ( 3) a_bitangent                    */
    COLOR0    =  4, /** ( 4) a_color0                       */
    COLOR1    =  5, /** ( 5) a_color1                       */
    COLOR2    =  6, /** ( 6) a_color2                       */
    COLOR3    =  7, /** ( 7) a_color3                       */
    INDICES   =  8, /** ( 8) a_indices                      */
    WEIGHT    =  9, /** ( 9) a_weight                       */
    TEXCOORD0 = 10, /** (10) a_texcoord0                    */
    TEXCOORD1 = 11, /** (11) a_texcoord1                    */
    TEXCOORD2 = 12, /** (12) a_texcoord2                    */
    TEXCOORD3 = 13, /** (13) a_texcoord3                    */
    TEXCOORD4 = 14, /** (14) a_texcoord4                    */
    TEXCOORD5 = 15, /** (15) a_texcoord5                    */
    TEXCOORD6 = 16, /** (16) a_texcoord6                    */
    TEXCOORD7 = 17, /** (17) a_texcoord7                    */
    COUNT     = 18,
}

/**
 * Vertex attribute type enum.
 *
 */
attrib_type_t :: enum c.int {
    UINT8  = 0, /** ( 0) Uint8                                                              */
    UINT10 = 1, /** ( 1) Uint10, availability depends on: `BGFX_CAPS_VERTEX_ATTRIB_UINT10`. */
    INT16  = 2, /** ( 2) Int16                                                              */
    HALF   = 3, /** ( 3) Half, availability depends on: `BGFX_CAPS_VERTEX_ATTRIB_HALF`.     */
    FLOAT  = 4, /** ( 4) Float                                                              */
    COUNT  = 5,
}

/**
 * Texture format enum.
 * Notation:
 *       RGBA16S
 *       ^   ^ ^
 *       |   | +-- [ ]Unorm
 *       |   |     [F]loat
 *       |   |     [S]norm
 *       |   |     [I]nt
 *       |   |     [U]int
 *       |   +---- Number of bits per component
 *       +-------- Components
 * @attention Availability depends on Caps (see: formats).
 *
 */
texture_format_t :: enum c.int {
    BC1          =  0, /** ( 0) DXT1 R5G6B5A1                  */
    BC2          =  1, /** ( 1) DXT3 R5G6B5A4                  */
    BC3          =  2, /** ( 2) DXT5 R5G6B5A8                  */
    BC4          =  3, /** ( 3) LATC1/ATI1 R8                  */
    BC5          =  4, /** ( 4) LATC2/ATI2 RG8                 */
    BC6H         =  5, /** ( 5) BC6H RGB16F                    */
    BC7          =  6, /** ( 6) BC7 RGB 4-7 bits per color channel, 0-8 bits alpha */
    ETC1         =  7, /** ( 7) ETC1 RGB8                      */
    ETC2         =  8, /** ( 8) ETC2 RGB8                      */
    ETC2A        =  9, /** ( 9) ETC2 RGBA8                     */
    ETC2A1       = 10, /** (10) ETC2 RGB8A1                    */
    PTC12        = 11, /** (11) PVRTC1 RGB 2BPP                */
    PTC14        = 12, /** (12) PVRTC1 RGB 4BPP                */
    PTC12A       = 13, /** (13) PVRTC1 RGBA 2BPP               */
    PTC14A       = 14, /** (14) PVRTC1 RGBA 4BPP               */
    PTC22        = 15, /** (15) PVRTC2 RGBA 2BPP               */
    PTC24        = 16, /** (16) PVRTC2 RGBA 4BPP               */
    ATC          = 17, /** (17) ATC RGB 4BPP                   */
    ATCE         = 18, /** (18) ATCE RGBA 8 BPP explicit alpha */
    ATCI         = 19, /** (19) ATCI RGBA 8 BPP interpolated alpha */
    ASTC4X4      = 20, /** (20) ASTC 4x4 8.0 BPP               */
    ASTC5X5      = 21, /** (21) ASTC 5x5 5.12 BPP              */
    ASTC6X6      = 22, /** (22) ASTC 6x6 3.56 BPP              */
    ASTC8X5      = 23, /** (23) ASTC 8x5 3.20 BPP              */
    ASTC8X6      = 24, /** (24) ASTC 8x6 2.67 BPP              */
    ASTC10X5     = 25, /** (25) ASTC 10x5 2.56 BPP             */
    UNKNOWN      = 26, /** (26) Compressed formats above.      */
    R1           = 27, /** (27)                                */
    A8           = 28, /** (28)                                */
    R8           = 29, /** (29)                                */
    R8I          = 30, /** (30)                                */
    R8U          = 31, /** (31)                                */
    R8S          = 32, /** (32)                                */
    R16          = 33, /** (33)                                */
    R16I         = 34, /** (34)                                */
    R16U         = 35, /** (35)                                */
    R16F         = 36, /** (36)                                */
    R16S         = 37, /** (37)                                */
    R32I         = 38, /** (38)                                */
    R32U         = 39, /** (39)                                */
    R32F         = 40, /** (40)                                */
    RG8          = 41, /** (41)                                */
    RG8I         = 42, /** (42)                                */
    RG8U         = 43, /** (43)                                */
    RG8S         = 44, /** (44)                                */
    RG16         = 45, /** (45)                                */
    RG16I        = 46, /** (46)                                */
    RG16U        = 47, /** (47)                                */
    RG16F        = 48, /** (48)                                */
    RG16S        = 49, /** (49)                                */
    RG32I        = 50, /** (50)                                */
    RG32U        = 51, /** (51)                                */
    RG32F        = 52, /** (52)                                */
    RGB8         = 53, /** (53)                                */
    RGB8I        = 54, /** (54)                                */
    RGB8U        = 55, /** (55)                                */
    RGB8S        = 56, /** (56)                                */
    RGB9E5F      = 57, /** (57)                                */
    BGRA8        = 58, /** (58)                                */
    RGBA8        = 59, /** (59)                                */
    RGBA8I       = 60, /** (60)                                */
    RGBA8U       = 61, /** (61)                                */
    RGBA8S       = 62, /** (62)                                */
    RGBA16       = 63, /** (63)                                */
    RGBA16I      = 64, /** (64)                                */
    RGBA16U      = 65, /** (65)                                */
    RGBA16F      = 66, /** (66)                                */
    RGBA16S      = 67, /** (67)                                */
    RGBA32I      = 68, /** (68)                                */
    RGBA32U      = 69, /** (69)                                */
    RGBA32F      = 70, /** (70)                                */
    R5G6B5       = 71, /** (71)                                */
    RGBA4        = 72, /** (72)                                */
    RGB5A1       = 73, /** (73)                                */
    RGB10A2      = 74, /** (74)                                */
    RG11B10F     = 75, /** (75)                                */
    UNKNOWNDEPTH = 76, /** (76) Depth formats below.           */
    D16          = 77, /** (77)                                */
    D24          = 78, /** (78)                                */
    D24S8        = 79, /** (79)                                */
    D32          = 80, /** (80)                                */
    D16F         = 81, /** (81)                                */
    D24F         = 82, /** (82)                                */
    D32F         = 83, /** (83)                                */
    D0S8         = 84, /** (84)                                */
    COUNT        = 85, 
}

/**
 * Uniform type enum.
 *
 */
uniform_type_t :: enum c.int {
    SAMPLER = 0, /** ( 0) Sampler.                       */
    END     = 1, /** ( 1) Reserved, do not use.          */
    VEC4    = 2, /** ( 2) 4 floats vector.               */
    MAT3    = 3, /** ( 3) 3x3 matrix.                    */
    MAT4    = 4, /** ( 4) 4x4 matrix.                    */
    COUNT   = 5,
}

/**
 * Backbuffer ratio enum.
 *
 */
backbuffer_ratio_t :: enum c.int {
    EQUAL     = 0, /** ( 0) Equal to backbuffer.              */
    HALF      = 1, /** ( 1) One half size of backbuffer.      */
    QUARTER   = 2, /** ( 2) One quarter size of backbuffer.   */
    EIGHTH    = 3, /** ( 3) One eighth size of backbuffer.    */
    SIXTEENTH = 4, /** ( 4) One sixteenth size of backbuffer. */
    DOUBLE    = 5, /** ( 5) Double size of backbuffer.        */
    COUNT     = 6,
}

/**
 * Occlusion query result.
 *
 */
occlusion_query_result_t :: enum c.int {
    INVISIBLE = 0, /** ( 0) Query failed test.                 */
    VISIBLE   = 1, /** ( 1) Query passed test.                 */
    NORESULT  = 2, /** ( 2) Query result is not available yet. */
    COUNT     = 3,
}

/**
 * Primitive topology.
 *
 */
topology_t :: enum c.int {
    TRI_LIST   = 0, /** ( 0) Triangle list.                 */
    TRI_STRIP  = 1, /** ( 1) Triangle strip.                */
    LINE_LIST  = 2, /** ( 2) Line list.                     */
    LINE_STRIP = 3, /** ( 3) Line strip.                    */
    POINT_LIST = 4, /** ( 4) Point list.                    */
    COUNT      = 5,
}

/**
 * Topology conversion function.
 *
 */
topology_convert_t :: enum c.int {
    TRI_LIST_FLIP_WINDING   = 0, /** ( 0) Flip winding order of triangle list.     */
    TRI_STRIP_FLIP_WINDING  = 1, /** ( 1) Flip winding order of triangle strip.    */
    TRI_LIST_TO_LINE_LIST   = 2, /** ( 2) Convert triangle list to line list.      */
    TRI_STRIP_TO_TRI_LIST   = 3, /** ( 3) Convert triangle strip to triangle list. */
    LINE_STRIP_TO_LINE_LIST = 4, /** ( 4) Convert line strip to line list.         */
    COUNT                   = 5,
}

/**
 * Topology sort order.
 *
 */
topology_sort_t :: enum c.int {
    DIRECTION_FRONT_TO_BACK_MIN =  0, /** ( 0)                                */
    DIRECTION_FRONT_TO_BACK_AVG =  1, /** ( 1)                                */
    DIRECTION_FRONT_TO_BACK_MAX =  2, /** ( 2)                                */
    DIRECTION_BACK_TO_FRONT_MIN =  3, /** ( 3)                                */
    DIRECTION_BACK_TO_FRONT_AVG =  4, /** ( 4)                                */
    DIRECTION_BACK_TO_FRONT_MAX =  5, /** ( 5)                                */
    DISTANCE_FRONT_TO_BACK_MIN  =  6, /** ( 6)                                */
    DISTANCE_FRONT_TO_BACK_AVG  =  7, /** ( 7)                                */
    DISTANCE_FRONT_TO_BACK_MAX  =  8, /** ( 8)                                */
    DISTANCE_BACK_TO_FRONT_MIN  =  9, /** ( 9)                                */
    DISTANCE_BACK_TO_FRONT_AVG  = 10, /** (10)                                */
    DISTANCE_BACK_TO_FRONT_MAX  = 11, /** (11)                                */
    COUNT                       = 12,
}

/**
 * View mode sets draw call sort order.
 *
 */
view_mode_t :: enum c.int {
    DEFAULT          = 0, /** ( 0) Default sort order.                                       */
    SEQUENTIAL       = 1, /** ( 1) Sort in the same order in which submit calls were called. */
    DEPTH_ASCENDING  = 2, /** ( 2) Sort draw call depth in ascending order.                  */
    DEPTH_DESCENDING = 3, /** ( 3) Sort draw call depth in descending order.                 */
    COUNT            = 4,
}

/**
 * Render frame enum.
 *
 */
render_frame_t :: enum c.int {
    NO_CONTEXT = 0, /** ( 0) Renderer context is not created yet.                                      */
    RENDER     = 1, /** ( 1) Renderer context is created and rendering.                                */
    TIMEOUT    = 2, /** ( 2) Renderer context wait for main thread signal timed out without rendering. */
    EXITING    = 3, /** ( 3) Renderer context is getting destroyed.                                    */
    COUNT      = 4,
}

view_id_t :: u16

allocator_interface_t :: struct {
    using vtbl: ^allocator_vtbl_t,
}
allocator_vtbl_t :: struct {
    realloc : proc "c" (_this: ^allocator_interface_t, _ptr: rawptr, _size, _align: c.size_t, _file: cstring, _line: c.uint32_t) -> rawptr,
}

dynamic_index_buffer_handle_t :: struct {
    idx: c.uint16_t,
}

dynamic_vertex_buffer_handle_t :: struct {
    idx: c.uint16_t,
}

frame_buffer_handle_t :: struct {
    idx: c.uint16_t,
}

index_buffer_handle_t :: struct {
    idx: c.uint16_t,
}

indirect_buffer_handle_t :: struct {
    idx: c.uint16_t,
}

occlusion_query_handle_t :: struct {
    idx: c.uint16_t,
}

program_handle_t :: struct {
    idx: c.uint16_t,
}

shader_handle_t :: struct {
    idx: c.uint16_t,
}

texture_handle_t :: struct {
    idx: c.uint16_t,
}

uniform_handle_t :: struct {
    idx: c.uint16_t,
}

vertex_buffer_handle_t :: struct {
    idx: c.uint16_t,
}

vertex_layout_handle_t :: struct {
    idx: c.uint16_t,
}

/**
 * Memory release callback.
 *
 * @param[in] _ptr Pointer to allocated data.
 * @param[in] _userData User defined data if needed.
 *
 */
release_fn_t :: #type proc "c" (_ptr, _userData: rawptr)

/**
 * GPU info.
 *
 */
caps_gpu_t :: struct {
    vendorId: c.uint16_t,  /** Vendor PCI id. See `BGFX_PCI_ID_*`.      */
    deviceId: c.uint16_t,  /** Device id.                               */
}

/**
 * Renderer runtime limits.
 *
 */
caps_limits_t :: struct {
    maxDrawCalls:            c.uint32_t, /** Maximum number of draw calls.            */
    maxBlits:                c.uint32_t, /** Maximum number of blit calls.            */
    maxTextureSize:          c.uint32_t, /** Maximum texture size.                    */
    maxTextureLayers:        c.uint32_t, /** Maximum texture layers.                  */
    maxViews:                c.uint32_t, /** Maximum number of views.                 */
    maxFrameBuffers:         c.uint32_t, /** Maximum number of frame buffer handles.  */
    maxFBAttachments:        c.uint32_t, /** Maximum number of frame buffer attachments. */
    maxPrograms:             c.uint32_t, /** Maximum number of program handles.       */
    maxShaders:              c.uint32_t, /** Maximum number of shader handles.        */
    maxTextures:             c.uint32_t, /** Maximum number of texture handles.       */
    maxTextureSamplers:      c.uint32_t, /** Maximum number of texture samplers.      */
    maxComputeBindings:      c.uint32_t, /** Maximum number of compute bindings.      */
    maxVertexLayouts:        c.uint32_t, /** Maximum number of vertex format layouts. */
    maxVertexStreams:        c.uint32_t, /** Maximum number of vertex streams.        */
    maxIndexBuffers:         c.uint32_t, /** Maximum number of index buffer handles.  */
    maxVertexBuffers:        c.uint32_t, /** Maximum number of vertex buffer handles. */
    maxDynamicIndexBuffers:  c.uint32_t, /** Maximum number of dynamic index buffer handles. */
    maxDynamicVertexBuffers: c.uint32_t, /** Maximum number of dynamic vertex buffer handles. */
    maxUniforms:             c.uint32_t, /** Maximum number of uniform handles.       */
    maxOcclusionQueries:     c.uint32_t, /** Maximum number of occlusion query handles. */
    maxEncoders:             c.uint32_t, /** Maximum number of encoder threads.       */
    minResourceCbSize:       c.uint32_t, /** Minimum resource command buffer size.    */
    transientVbSize:         c.uint32_t, /** Maximum transient vertex buffer size.    */
    transientIbSize:         c.uint32_t, /** Maximum transient index buffer size.     */
}

/**
 * Renderer capabilities.
 *
 */
caps_t :: struct {
    rendererType: renderer_type_t,       /** Renderer backend type. See: `bgfx::RendererType` */
    
    /**
     * Supported functionality.
     *   @attention See `BGFX_CAPS_*` flags at https://bkaradzic.github.io/bgfx/bgfx.html#available-caps
     */
    supported:        c.uint64_t,             
    vendorId:         c.uint16_t,         /** Selected GPU vendor PCI id.              */
    deviceId:         c.uint16_t,         /** Selected GPU device id.                  */
    homogeneousDepth: c.bool,             /** True when NDC depth is in [-1, 1] range, otherwise its [0, 1]. */
    originBottomLeft: c.bool,             /** True when NDC origin is at bottom left.  */
    numGPUs:          c.uint8_t,          /** Number of enumerated GPUs.               */
    gpu:              [4]caps_gpu_t,      /** Enumerated GPUs.                         */
    limits:           caps_limits_t,      /** Renderer runtime limits.                 */
    
    /**
     * Supported texture format capabilities flags:
     *   - `BGFX_CAPS_FORMAT_TEXTURE_NONE` - Texture format is not supported.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_2D` - Texture format is supported.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_2D_SRGB` - Texture as sRGB format is supported.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_2D_EMULATED` - Texture format is emulated.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_3D` - Texture format is supported.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_3D_SRGB` - Texture as sRGB format is supported.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_3D_EMULATED` - Texture format is emulated.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_CUBE` - Texture format is supported.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_CUBE_SRGB` - Texture as sRGB format is supported.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_CUBE_EMULATED` - Texture format is emulated.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_VERTEX` - Texture format can be used from vertex shader.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_IMAGE_READ` - Texture format can be used as image
     *     and read from.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_IMAGE_WRITE` - Texture format can be used as image
     *     and written to.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER` - Texture format can be used as frame
     *     buffer.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER_MSAA` - Texture format can be used as MSAA
     *     frame buffer.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_MSAA` - Texture can be sampled as MSAA.
     *   - `BGFX_CAPS_FORMAT_TEXTURE_MIP_AUTOGEN` - Texture format supports auto-generated
     *     mips.
     */
    formats: [texture_format_t.COUNT]c.uint16_t,
}

/**
 * Internal data.
 *
 */
internal_data_t :: struct {
    caps: ^caps_t,    /** Renderer capabilities.                   */
    // @note(zh): renamed context -> ctx, since it's a keyword in Odin
    ctx: rawptr,      /** GL context, or D3D device.               */
}

/**
 * Platform data.
 *
 */
platform_data_t :: struct {
    ndt: rawptr,             /** Native display type (*nix specific).     */
    
    /**
     * Native window handle. If `NULL` bgfx will create headless
     * context/device if renderer API supports it.
     */
    nwh: rawptr,
    ctx: rawptr,            /** GL context, or D3D device. If `NULL`, bgfx will create context/device. */
    
    /**
     * GL back-buffer, or D3D render target view. If `NULL` bgfx will
     * create back-buffer color surface.
     */
    backBuffer: rawptr,
    
    /**
     * Backbuffer depth/stencil. If `NULL` bgfx will create back-buffer
     * depth/stencil surface.
     */
    backBufferDS: rawptr,
}

/**
 * Backbuffer resolution and reset parameters.
 *
 */
resolution_t :: struct {
    format:          texture_format_t,    /** Backbuffer format.                       */
    width:           c.uint32_t,          /** Backbuffer width.                        */
    height:          c.uint32_t,          /** Backbuffer height.                       */
    reset:           c.uint32_t,          /** Reset parameters.                        */
    numBackBuffers:  c.uint8_t,           /** Number of back buffers.                  */
    maxFrameLatency: c.uint8_t,           /** Maximum frame latency.                   */
}

/**
 * Configurable runtime limits parameters.
 *
 */
init_limits_t :: struct {
    maxEncoders:       c.uint16_t,  /** Maximum number of encoder threads.       */
    minResourceCbSize: c.uint32_t,  /** Minimum resource command buffer size.    */
    transientVbSize:   c.uint32_t,  /** Maximum transient vertex buffer size.    */
    transientIbSize:   c.uint32_t,  /** Maximum transient index buffer size.     */
}

/**
 * Initialization parameters used by `bgfx::init`.
 *
 */
init_t :: struct {
    /**
     * Select rendering backend. When set to RendererType::Count
     * a default rendering backend will be selected appropriate to the platform.
     * See: `bgfx::RendererType`
     */
    type: renderer_type_t,
    
    /**
     * Vendor PCI id. If set to `BGFX_PCI_ID_NONE` it will select the first
     * device.
     *   - `BGFX_PCI_ID_NONE` - Autoselect adapter.
     *   - `BGFX_PCI_ID_SOFTWARE_RASTERIZER` - Software rasterizer.
     *   - `BGFX_PCI_ID_AMD` - AMD adapter.
     *   - `BGFX_PCI_ID_INTEL` - Intel adapter.
     *   - `BGFX_PCI_ID_NVIDIA` - nVidia adapter.
     */
    vendorId: c.uint16_t,
    
    /**
     * Device id. If set to 0 it will select first device, or device with
     * matching id.
     */
    deviceId:     c.uint16_t,             
    capabilities: c.uint64_t,      /** Capabilities initialization mask (default: UINT64_MAX). */
    debug:        c.bool,          /** Enable device for debuging.              */
    profile:      c.bool,          /** Enable device for profiling.             */
    platformData: platform_data_t, /** Platform data.                           */
    resolution:   resolution_t,    /** Backbuffer resolution and reset parameters. See: `bgfx::Resolution`. */
    limits:       init_limits_t,   /** Configurable runtime limits parameters.  */
    
    /**
     * Provide application specific callback interface.
     * See: `bgfx::CallbackI`
     */
    callback: ^callback_interface_t,
    
    /**
     * Custom allocator. When a custom allocator is not
     * specified, bgfx uses the CRT allocator. Bgfx assumes
     * custom allocator is thread safe.
     */
    allocator: ^allocator_interface_t,
}

/**
 * Memory must be obtained by calling `bgfx::alloc`, `bgfx::copy`, or `bgfx::makeRef`.
 * @attention It is illegal to create this structure on stack and pass it to any bgfx API.
 *
 */
memory_t :: struct {
    data: ^c.uint8_t,   /** Pointer to data.                         */
    size: c.uint32_t,   /** Data size.                               */
}

/**
 * Transient index buffer.
 *
 */
transient_index_buffer_t :: struct {
    data:       ^c.uint8_t,            /** Pointer to data.                         */
    size:       c.uint32_t,            /** Data size.                               */
    startIndex: c.uint32_t,            /** First index.                             */
    handle:     index_buffer_handle_t, /** Index buffer handle.                     */
    isIndex16:  c.bool,                /** Index buffer format is 16-bits if true, otherwise it is 32-bit. */
}

/**
 * Transient vertex buffer.
 *
 */
transient_vertex_buffer_t :: struct {
    data:         ^c.uint8_t,             /** Pointer to data.                         */
    size:         c.uint32_t,             /** Data size.                               */
    startVertex:  c.uint32_t,             /** First vertex.                            */
    stride:       c.uint16_t,             /** Vertex stride.                           */
    handle:       vertex_buffer_handle_t, /** Vertex buffer handle.                    */
    layoutHandle: vertex_layout_handle_t, /** Vertex layout handle.                    */
}

/**
 * Instance data buffer info.
 *
 */
instance_data_buffer_t :: struct {
    data:   ^c.uint8_t,             /** Pointer to data.                         */
    size:   c.uint32_t,             /** Data size.                               */
    offset: c.uint32_t,             /** Offset in vertex buffer.                 */
    num:    c.uint32_t,             /** Number of instances.                     */
    stride: c.uint16_t,             /** Vertex buffer stride.                    */
    handle: vertex_buffer_handle_t, /** Vertex buffer object handle.             */
}

/**
 * Texture info.
 *
 */
texture_info_t :: struct {
    format:       texture_format_t, /** Texture format.                          */
    storageSize:  c.uint32_t,       /** Total amount of bytes required to store texture. */
    width:        c.uint16_t,       /** Texture width.                           */
    height:       c.uint16_t,       /** Texture height.                          */
    depth:        c.uint16_t,       /** Texture depth.                           */
    numLayers:    c.uint16_t,       /** Number of layers in texture array.       */
    numMips:      c.uint8_t,        /** Number of MIP maps.                      */
    bitsPerPixel: c.uint8_t,        /** Format bits per pixel.                   */
    cubeMap:      c.bool,           /** Texture is cubemap.                      */
}

/**
 * Uniform info.
 *
 */
uniform_info_t :: struct {
    name: [256]c.char,    /** Uniform name.                            */
    type: uniform_type_t, /** Uniform type.                            */
    num:  c.uint16_t,     /** Number of elements in array.             */
}

/**
 * Frame buffer texture attachment info.
 *
 */
attachment_t :: struct {
    access:    access_t,         /** Attachment access. See `Access::Enum`.   */
    handle:    texture_handle_t, /** Render target texture handle.            */
    mip:       c.uint16_t,       /** Mip level.                               */
    layer:     c.uint16_t,       /** Cubemap side or depth layer/slice to use. */
    numLayers: c.uint16_t,       /** Number of texture layer/slice(s) in array to use. */
    resolve:   c.uint8_t,        /** Resolve flags. See: `BGFX_RESOLVE_*`     */
}

/**
 * Transform data.
 *
 */
transform_t :: struct {
    data: ^c.float,   /** Pointer to first 4x4 matrix.             */
    num:  c.uint16_t, /** Number of matrices.                      */
}

/**
 * View stats.
 *
 */
view_stats_t :: struct {
    name:         [256]c.char, /** View name.                               */
    view:         view_id_t,   /** View id.                                 */
    cpuTimeBegin: c.int64_t,   /** CPU (submit) begin time.                 */
    cpuTimeEnd:   c.int64_t,   /** CPU (submit) end time.                   */
    gpuTimeBegin: c.int64_t,   /** GPU begin time.                          */
    gpuTimeEnd:   c.int64_t,   /** GPU end time.                            */
}

/**
 * Encoder stats.
 *
 */
encoder_stats_t :: struct {
    cpuTimeBegin: c.int64_t, /** Encoder thread CPU submit begin time.    */
    cpuTimeEnd:   c.int64_t, /** Encoder thread CPU submit end time.      */
}

/**
 * Renderer statistics data.
 * @remarks All time values are high-resolution timestamps, while
 * time frequencies define timestamps-per-second for that hardware.
 *
 */
stats_t :: struct {
    cpuTimeFrame:            c.int64_t,                    /** CPU time between two `bgfx::frame` calls. */
    cpuTimeBegin:            c.int64_t,                    /** Render thread CPU submit begin time.     */
    cpuTimeEnd:              c.int64_t,                    /** Render thread CPU submit end time.       */
    cpuTimerFreq:            c.int64_t,                    /** CPU timer frequency. Timestamps-per-second */
    gpuTimeBegin:            c.int64_t,                    /** GPU frame begin time.                    */
    gpuTimeEnd:              c.int64_t,                    /** GPU frame end time.                      */
    gpuTimerFreq:            c.int64_t,                    /** GPU timer frequency.                     */
    waitRender:              c.int64_t,                    /** Time spent waiting for render backend thread to finish issuing draw commands to underlying graphics API. */
    waitSubmit:              c.int64_t,                    /** Time spent waiting for submit thread to advance to next frame. */
    numDraw:                 c.uint32_t,                   /** Number of draw calls submitted.          */
    numCompute:              c.uint32_t,                   /** Number of compute calls submitted.       */
    numBlit:                 c.uint32_t,                   /** Number of blit calls submitted.          */
    maxGpuLatency:           c.uint32_t,                   /** GPU driver latency.                      */
    numDynamicIndexBuffers:  c.uint16_t,                   /** Number of used dynamic index buffers.    */
    numDynamicVertexBuffers: c.uint16_t,                   /** Number of used dynamic vertex buffers.   */
    numFrameBuffers:         c.uint16_t,                   /** Number of used frame buffers.            */
    numIndexBuffers:         c.uint16_t,                   /** Number of used index buffers.            */
    numOcclusionQueries:     c.uint16_t,                   /** Number of used occlusion queries.        */
    numPrograms:             c.uint16_t,                   /** Number of used programs.                 */
    numShaders:              c.uint16_t,                   /** Number of used shaders.                  */
    numTextures:             c.uint16_t,                   /** Number of used textures.                 */
    numUniforms:             c.uint16_t,                   /** Number of used uniforms.                 */
    numVertexBuffers:        c.uint16_t,                   /** Number of used vertex buffers.           */
    numVertexLayouts:        c.uint16_t,                   /** Number of used vertex layouts.           */
    textureMemoryUsed:       c.int64_t,                    /** Estimate of texture memory used.         */
    rtMemoryUsed:            c.int64_t,                    /** Estimate of render target memory used.   */
    transientVbUsed:         c.int32_t,                    /** Amount of transient vertex buffer used.  */
    transientIbUsed:         c.int32_t,                    /** Amount of transient index buffer used.   */
    numPrims:                [topology_t.COUNT]c.uint32_t, /** Number of primitives rendered.           */
    gpuMemoryMax:            c.int64_t,                    /** Maximum available GPU memory for application. */
    gpuMemoryUsed:           c.int64_t,                    /** Amount of GPU memory used by the application. */
    width:                   c.uint16_t,                   /** Backbuffer width in pixels.              */
    height:                  c.uint16_t,                   /** Backbuffer height in pixels.             */
    textWidth:               c.uint16_t,                   /** Debug text width in characters.          */
    textHeight:              c.uint16_t,                   /** Debug text height in characters.         */
    numViews:                c.uint16_t,                   /** Number of view stats.                    */
    viewStats:               ^view_stats_t,              /** Array of View stats.                     */
    numEncoders:             c.uint8_t,                    /** Number of encoders used during frame.    */
    encoderStats:            ^encoder_stats_t,           /** Array of encoder stats.                  */
}

/**
 * Vertex layout.
 *
 */
vertex_layout_t :: struct {
    hash:       c.uint32_t,                 /** Hash.                                    */
    stride:     c.uint16_t,                 /** Stride.                                  */
    offset:     [attrib_t.COUNT]c.uint16_t, /** Attribute offsets.                       */
    attributes: [attrib_t.COUNT]c.uint16_t, /** Used attributes.                         */
}

/**
 * Encoders are used for submitting draw calls from multiple threads. Only one encoder
 * per thread should be used. Use `bgfx::begin()` to obtain an encoder for a thread.
 *
 */
encoder_t :: struct {}

function_id_t :: enum c.int {
    ATTACHMENT_INIT,
    VERTEX_LAYOUT_BEGIN,
    VERTEX_LAYOUT_ADD,
    VERTEX_LAYOUT_DECODE,
    VERTEX_LAYOUT_HAS,
    VERTEX_LAYOUT_SKIP,
    VERTEX_LAYOUT_END,
    VERTEX_PACK,
    VERTEX_UNPACK,
    VERTEX_CONVERT,
    WELD_VERTICES,
    TOPOLOGY_CONVERT,
    TOPOLOGY_SORT_TRI_LIST,
    GET_SUPPORTED_RENDERERS,
    GET_RENDERER_NAME,
    INIT_CTOR,
    INIT,
    SHUTDOWN,
    RESET,
    FRAME,
    GET_RENDERER_TYPE,
    GET_CAPS,
    GET_STATS,
    ALLOC,
    COPY,
    MAKE_REF,
    MAKE_REF_RELEASE,
    SET_DEBUG,
    DBG_TEXT_CLEAR,
    DBG_TEXT_PRINTF,
    DBG_TEXT_VPRINTF,
    DBG_TEXT_IMAGE,
    CREATE_INDEX_BUFFER,
    SET_INDEX_BUFFER_NAME,
    DESTROY_INDEX_BUFFER,
    CREATE_VERTEX_LAYOUT,
    DESTROY_VERTEX_LAYOUT,
    CREATE_VERTEX_BUFFER,
    SET_VERTEX_BUFFER_NAME,
    DESTROY_VERTEX_BUFFER,
    CREATE_DYNAMIC_INDEX_BUFFER,
    CREATE_DYNAMIC_INDEX_BUFFER_MEM,
    UPDATE_DYNAMIC_INDEX_BUFFER,
    DESTROY_DYNAMIC_INDEX_BUFFER,
    CREATE_DYNAMIC_VERTEX_BUFFER,
    CREATE_DYNAMIC_VERTEX_BUFFER_MEM,
    UPDATE_DYNAMIC_VERTEX_BUFFER,
    DESTROY_DYNAMIC_VERTEX_BUFFER,
    GET_AVAIL_TRANSIENT_INDEX_BUFFER,
    GET_AVAIL_TRANSIENT_VERTEX_BUFFER,
    GET_AVAIL_INSTANCE_DATA_BUFFER,
    ALLOC_TRANSIENT_INDEX_BUFFER,
    ALLOC_TRANSIENT_VERTEX_BUFFER,
    ALLOC_TRANSIENT_BUFFERS,
    ALLOC_INSTANCE_DATA_BUFFER,
    CREATE_INDIRECT_BUFFER,
    DESTROY_INDIRECT_BUFFER,
    CREATE_SHADER,
    GET_SHADER_UNIFORMS,
    SET_SHADER_NAME,
    DESTROY_SHADER,
    CREATE_PROGRAM,
    CREATE_COMPUTE_PROGRAM,
    DESTROY_PROGRAM,
    IS_TEXTURE_VALID,
    IS_FRAME_BUFFER_VALID,
    CALC_TEXTURE_SIZE,
    CREATE_TEXTURE,
    CREATE_TEXTURE_2D,
    CREATE_TEXTURE_2D_SCALED,
    CREATE_TEXTURE_3D,
    CREATE_TEXTURE_CUBE,
    UPDATE_TEXTURE_2D,
    UPDATE_TEXTURE_3D,
    UPDATE_TEXTURE_CUBE,
    READ_TEXTURE,
    SET_TEXTURE_NAME,
    GET_DIRECT_ACCESS_PTR,
    DESTROY_TEXTURE,
    CREATE_FRAME_BUFFER,
    CREATE_FRAME_BUFFER_SCALED,
    CREATE_FRAME_BUFFER_FROM_HANDLES,
    CREATE_FRAME_BUFFER_FROM_ATTACHMENT,
    CREATE_FRAME_BUFFER_FROM_NWH,
    SET_FRAME_BUFFER_NAME,
    GET_TEXTURE,
    DESTROY_FRAME_BUFFER,
    CREATE_UNIFORM,
    GET_UNIFORM_INFO,
    DESTROY_UNIFORM,
    CREATE_OCCLUSION_QUERY,
    GET_RESULT,
    DESTROY_OCCLUSION_QUERY,
    SET_PALETTE_COLOR,
    SET_PALETTE_COLOR_RGBA8,
    SET_VIEW_NAME,
    SET_VIEW_RECT,
    SET_VIEW_RECT_RATIO,
    SET_VIEW_SCISSOR,
    SET_VIEW_CLEAR,
    SET_VIEW_CLEAR_MRT,
    SET_VIEW_MODE,
    SET_VIEW_FRAME_BUFFER,
    SET_VIEW_TRANSFORM,
    SET_VIEW_ORDER,
    RESET_VIEW,
    ENCODER_BEGIN,
    ENCODER_END,
    ENCODER_SET_MARKER,
    ENCODER_SET_STATE,
    ENCODER_SET_CONDITION,
    ENCODER_SET_STENCIL,
    ENCODER_SET_SCISSOR,
    ENCODER_SET_SCISSOR_CACHED,
    ENCODER_SET_TRANSFORM,
    ENCODER_SET_TRANSFORM_CACHED,
    ENCODER_ALLOC_TRANSFORM,
    ENCODER_SET_UNIFORM,
    ENCODER_SET_INDEX_BUFFER,
    ENCODER_SET_DYNAMIC_INDEX_BUFFER,
    ENCODER_SET_TRANSIENT_INDEX_BUFFER,
    ENCODER_SET_VERTEX_BUFFER,
    ENCODER_SET_VERTEX_BUFFER_WITH_LAYOUT,
    ENCODER_SET_DYNAMIC_VERTEX_BUFFER,
    ENCODER_SET_DYNAMIC_VERTEX_BUFFER_WITH_LAYOUT,
    ENCODER_SET_TRANSIENT_VERTEX_BUFFER,
    ENCODER_SET_TRANSIENT_VERTEX_BUFFER_WITH_LAYOUT,
    ENCODER_SET_VERTEX_COUNT,
    ENCODER_SET_INSTANCE_DATA_BUFFER,
    ENCODER_SET_INSTANCE_DATA_FROM_VERTEX_BUFFER,
    ENCODER_SET_INSTANCE_DATA_FROM_DYNAMIC_VERTEX_BUFFER,
    ENCODER_SET_INSTANCE_COUNT,
    ENCODER_SET_TEXTURE,
    ENCODER_TOUCH,
    ENCODER_SUBMIT,
    ENCODER_SUBMIT_OCCLUSION_QUERY,
    ENCODER_SUBMIT_INDIRECT,
    ENCODER_SET_COMPUTE_INDEX_BUFFER,
    ENCODER_SET_COMPUTE_VERTEX_BUFFER,
    ENCODER_SET_COMPUTE_DYNAMIC_INDEX_BUFFER,
    ENCODER_SET_COMPUTE_DYNAMIC_VERTEX_BUFFER,
    ENCODER_SET_COMPUTE_INDIRECT_BUFFER,
    ENCODER_SET_IMAGE,
    ENCODER_DISPATCH,
    ENCODER_DISPATCH_INDIRECT,
    ENCODER_DISCARD,
    ENCODER_BLIT,
    REQUEST_SCREEN_SHOT,
    RENDER_FRAME,
    SET_PLATFORM_DATA,
    GET_INTERNAL_DATA,
    OVERRIDE_INTERNAL_TEXTURE_PTR,
    OVERRIDE_INTERNAL_TEXTURE,
    SET_MARKER,
    SET_STATE,
    SET_CONDITION,
    SET_STENCIL,
    SET_SCISSOR,
    SET_SCISSOR_CACHED,
    SET_TRANSFORM,
    SET_TRANSFORM_CACHED,
    ALLOC_TRANSFORM,
    SET_UNIFORM,
    SET_INDEX_BUFFER,
    SET_DYNAMIC_INDEX_BUFFER,
    SET_TRANSIENT_INDEX_BUFFER,
    SET_VERTEX_BUFFER,
    SET_VERTEX_BUFFER_WITH_LAYOUT,
    SET_DYNAMIC_VERTEX_BUFFER,
    SET_DYNAMIC_VERTEX_BUFFER_WITH_LAYOUT,
    SET_TRANSIENT_VERTEX_BUFFER,
    SET_TRANSIENT_VERTEX_BUFFER_WITH_LAYOUT,
    SET_VERTEX_COUNT,
    SET_INSTANCE_DATA_BUFFER,
    SET_INSTANCE_DATA_FROM_VERTEX_BUFFER,
    SET_INSTANCE_DATA_FROM_DYNAMIC_VERTEX_BUFFER,
    SET_INSTANCE_COUNT,
    SET_TEXTURE,
    TOUCH,
    SUBMIT,
    SUBMIT_OCCLUSION_QUERY,
    SUBMIT_INDIRECT,
    SET_COMPUTE_INDEX_BUFFER,
    SET_COMPUTE_VERTEX_BUFFER,
    SET_COMPUTE_DYNAMIC_INDEX_BUFFER,
    SET_COMPUTE_DYNAMIC_VERTEX_BUFFER,
    SET_COMPUTE_INDIRECT_BUFFER,
    SET_IMAGE,
    DISPATCH,
    DISPATCH_INDIRECT,
    DISCARD,
    BLIT,
    COUNT,
}