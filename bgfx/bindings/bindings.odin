package bgfx_bindings

/*
    Copyright 2021 zhibog
    License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause

    List of contributors:
        zhibog: Initial implementation.

    Bindings for BGFX, using its C API header, located at <https://github.com/bkaradzic/bgfx/blob/master/include/bgfx/c99/bgfx.h>

    The "bgfx_" prefix has been stripped from the identifiers to remove redundancy.
*/

import "core:c"

when ODIN_OS == "windows" {
    foreign import lib {
        "lib/bgfx.lib",
        "lib/bimg.lib",
        "lib/bimg_decode.lib",
        "lib/bx.lib",
        "system:user32.lib",
        "system:gdi32.lib",
        "system:shell32.lib",
    }
}

HANDLE_IS_VALID :: proc "c" (h: ^$T) -> bool {
    return h.idx != max(c.uint16_t)
}

callback_interface_t :: struct {
    using vtbl: ^callback_vtbl_t,
}
callback_vtbl_t :: struct {
    fatal                  : proc "c" (_this: ^callback_interface_t, _filePath: cstring, _line: c.uint16_t, _code: fatal_t, _str: cstring),
    trace_vargs            : proc "c" (_this: ^callback_interface_t, _filePath: cstring, _line: c.uint16_t, _format: cstring, _argList: ..cstring),
    profiler_begin         : proc "c" (_this: ^callback_interface_t, _name: cstring, _abgr: c.uint32_t, _filePath: cstring, _line: c.uint16_t),
    profiler_begin_literal : proc "c" (_this: ^callback_interface_t, _name: cstring, _abgr: c.uint32_t, _filePath: cstring, _line: c.uint16_t),
    profiler_end           : proc "c" (_this: ^callback_interface_t),
    cache_read_size        : proc "c" (_this: ^callback_interface_t, _id: c.uint64_t) -> c.uint32_t,
    cache_read             : proc "c" (_this: ^callback_interface_t, _id: c.uint64_t, _data: rawptr, _size: c.uint32_t) -> c.bool,
    cache_write            : proc "c" (_this: ^callback_interface_t, _id: c.uint64_t, _data: rawptr, _size: c.uint32_t),
    screen_shot            : proc "c" (_this: ^callback_interface_t, _filePath: cstring, _width, _height, _pitch: c.uint32_t, data: rawptr, _size: c.uint32_t, _yflip: c.bool),
    capture_begin          : proc "c" (_this: ^callback_interface_t, _width, _height, _pitch: c.uint32_t, _format: texture_format_t, _yflip: c.bool),
    capture_end            : proc "c" (_this: ^callback_interface_t),
    capture_frame          : proc "c" (_this: ^callback_interface_t, _data: rawptr, _size: c.uint32_t),
}

@(default_calling_convention="c", link_prefix="bgfx_")
foreign lib {
    /**
     * Init attachment.
     *
     * @param[in] _handle Render target texture handle.
     * @param[in] _access Access. See `Access::Enum`.
     * @param[in] _layer Cubemap side or depth layer/slice to use.
     * @param[in] _numLayers Number of texture layer/slice(s) in array to use.
     * @param[in] _mip Mip level.
     * @param[in] _resolve Resolve flags. See: `BGFX_RESOLVE_*`
     *
     */
    attachment_init :: proc(_this: ^attachment_t, _handle: texture_handle_t, _access: access_t, _layer, _numLayers, _mip: c.uint16_t, _resolve: c.uint8_t) ---

    /**
     * Start VertexLayout.
     *
     * @param[in] _rendererType Renderer backend type. See: `bgfx::RendererType`
     *
     * @returns Returns itself.
     *
     */
    vertex_layout_begin :: proc(_this: ^vertex_layout_t, _rendererType: renderer_type_t) -> ^vertex_layout_t ---

    /**
     * Add attribute to VertexLayout.
     * @remarks Must be called between begin/end.
     *
     * @param[in] _attrib Attribute semantics. See: `bgfx::Attrib`
     * @param[in] _num Number of elements 1, 2, 3 or 4.
     * @param[in] _type Element type.
     * @param[in] _normalized When using fixed point AttribType (f.e. Uint8)
     *  value will be normalized for vertex shader usage. When normalized
     *  is set to true, AttribType::Uint8 value in range 0-255 will be
     *  in range 0.0-1.0 in vertex shader.
     * @param[in] _asInt Packaging rule for vertexPack, vertexUnpack, and
     *  vertexConvert for AttribType::Uint8 and AttribType::Int16.
     *  Unpacking code must be implemented inside vertex shader.
     *
     * @returns Returns itself.
     *
     */
    vertex_layout_add :: proc(_this: ^vertex_layout_t, _attrib: attrib_t, _num: c.uint8_t, _type: attrib_type_t, _normalized, _asInt: c.bool) -> ^vertex_layout_t ---

    /**
     * Decode attribute.
     *
     * @param[in] _attrib Attribute semantics. See: `bgfx::Attrib`
     * @param[out] _num Number of elements.
     * @param[out] _type Element type.
     * @param[out] _normalized Attribute is normalized.
     * @param[out] _asInt Attribute is packed as int.
     *
     */
    vertex_layout_decode :: proc(_this: ^vertex_layout_t, _attrib: attrib_t, _num: ^c.uint8_t, _type: ^attrib_type_t, _normalized, _asInt: ^c.bool) ---

    /**
     * Returns `true` if VertexLayout contains attribute.
     *
     * @param[in] _attrib Attribute semantics. See: `bgfx::Attrib`
     *
     * @returns True if VertexLayout contains attribute.
     *
     */
    vertex_layout_has :: proc(_this: ^vertex_layout_t, _attrib: attrib_t) -> c.bool ---

    /**
     * Skip `_num` bytes in vertex stream.
     *
     * @param[in] _num Number of bytes to skip.
     *
     * @returns Returns itself.
     *
     */
    vertex_layout_skip:: proc(_this: ^vertex_layout_t, _num: c.uint8_t) -> vertex_layout_t ---

    /**
     * End VertexLayout.
     *
     */
    vertex_layout_end:: proc(_this: ^vertex_layout_t) ---

    /**
     * Pack vertex attribute into vertex stream format.
     *
     * @param[in] _input Value to be packed into vertex stream.
     * @param[in] _inputNormalized `true` if input value is already normalized.
     * @param[in] _attr Attribute to pack.
     * @param[in] _layout Vertex stream layout.
     * @param[in] _data Destination vertex stream where data will be packed.
     * @param[in] _index Vertex index that will be modified.
     *
     */
    vertex_pack :: proc(_input: [4]c.float, _inputNormalized: c.bool, _attr: attrib_t, _layout: ^vertex_layout_t, _data: rawptr, _index: c.uint32_t) ---

    /**
     * Unpack vertex attribute from vertex stream format.
     *
     * @param[out] _output Result of unpacking.
     * @param[in] _attr Attribute to unpack.
     * @param[in] _layout Vertex stream layout.
     * @param[in] _data Source vertex stream from where data will be unpacked.
     * @param[in] _index Vertex index that will be unpacked.
     *
     */
    vertex_unpack :: proc(_output: [4]c.float, _attr: attrib_t, _layout: ^vertex_layout_t, _data: rawptr, _index: c.uint32_t) ---

    /**
     * Converts vertex stream data from one vertex stream format to another.
     *
     * @param[in] _dstLayout Destination vertex stream layout.
     * @param[in] _dstData Destination vertex stream.
     * @param[in] _srcLayout Source vertex stream layout.
     * @param[in] _srcData Source vertex stream data.
     * @param[in] _num Number of vertices to convert from source to destination.
     *
     */
    vertex_convert :: proc(_dstLayout: ^vertex_layout_t, _dstData: rawptr, _srcLayout: ^vertex_layout_t, _srcData: rawptr, _num: c.uint32_t) ---

    /**
     * Weld vertices.
     *
     * @param[in] _output Welded vertices remapping table. The size of buffer
     *  must be the same as number of vertices.
     * @param[in] _layout Vertex stream layout.
     * @param[in] _data Vertex stream.
     * @param[in] _num Number of vertices in vertex stream.
     * @param[in] _index32 Set to `true` if input indices are 32-bit.
     * @param[in] _epsilon Error tolerance for vertex position comparison.
     *
     * @returns Number of unique vertices after vertex welding.
     *
     */
    weld_vertices :: proc(_output: rawptr, _layout: ^vertex_layout_t, _data: rawptr, _num: c.uint32_t, _index32: c.bool, _epsilon: c.float) -> c.uint32_t ---

    /**
     * Convert index buffer for use with different primitive topologies.
     *
     * @param[in] _conversion Conversion type, see `TopologyConvert::Enum`.
     * @param[out] _dst Destination index buffer. If this argument is NULL
     *  function will return number of indices after conversion.
     * @param[in] _dstSize Destination index buffer in bytes. It must be
     *  large enough to contain output indices. If destination size is
     *  insufficient index buffer will be truncated.
     * @param[in] _indices Source indices.
     * @param[in] _numIndices Number of input indices.
     * @param[in] _index32 Set to `true` if input indices are 32-bit.
     *
     * @returns Number of output indices after conversion.
     *
     */
    topology_convert :: proc(_conversion: topology_convert_t, _dst: rawptr, _dstSize: c.uint32_t, _indices: rawptr, _numIndices: c.uint32_t, _index32: c.bool) -> c.uint32_t ---

    /**
     * Sort indices.
     *
     * @param[in] _sort Sort order, see `TopologySort::Enum`.
     * @param[out] _dst Destination index buffer.
     * @param[in] _dstSize Destination index buffer in bytes. It must be
     *  large enough to contain output indices. If destination size is
     *  insufficient index buffer will be truncated.
     * @param[in] _dir Direction (vector must be normalized).
     * @param[in] _pos Position.
     * @param[in] _vertices Pointer to first vertex represented as
     *  float x, y, z. Must contain at least number of vertices
     *  referencende by index buffer.
     * @param[in] _stride Vertex stride.
     * @param[in] _indices Source indices.
     * @param[in] _numIndices Number of input indices.
     * @param[in] _index32 Set to `true` if input indices are 32-bit.
     *
     */
    topology_sort_tri_list :: proc(_sort: topology_sort_t, _dst: rawptr, _dstSize: c.uint32_t, _dir, _pos: [3]c.float, _vertices: rawptr, _stride: c.uint32_t, _indices: rawptr,
                                   _numIndices: c.uint32_t, _index32: c.bool) ---

    /**
     * Returns supported backend API renderers.
     *
     * @param[in] _max Maximum number of elements in _enum array.
     * @param[inout] _enum Array where supported renderers will be written.
     *
     * @returns Number of supported renderers.
     *
     */
    get_supported_renderers :: proc(_max: c.uint8_t, _enum: ^renderer_type_t) ---

    /**
     * Returns name of renderer.
     *
     * @param[in] _type Renderer backend type. See: `bgfx::RendererType`
     *
     * @returns Name of renderer.
     *
     */
    get_renderer_name :: proc(_type: renderer_type_t) -> cstring ---
    init_ctor         :: proc(_init: ^init_t) ---

    /**
     * Initialize bgfx library.
     *
     * @param[in] _init Initialization parameters. See: `bgfx::Init` for more info.
     *
     * @returns `true` if initialization was successful.
     *
     */
    init :: proc(_init: ^init_t) ---

    /**
     * Shutdown bgfx library.
     *
     */
    shutdown :: proc() ---

    /**
     * Reset graphic settings and back-buffer size.
     * @attention This call doesn't actually change window size, it just
     *   resizes back-buffer. Windowing code has to change window size.
     *
     * @param[in] _width Back-buffer width.
     * @param[in] _height Back-buffer height.
     * @param[in] _flags See: `BGFX_RESET_*` for more info.
     *    - `BGFX_RESET_NONE` - No reset flags.
     *    - `BGFX_RESET_FULLSCREEN` - Not supported yet.
     *    - `BGFX_RESET_MSAA_X[2/4/8/16]` - Enable 2, 4, 8 or 16 x MSAA.
     *    - `BGFX_RESET_VSYNC` - Enable V-Sync.
     *    - `BGFX_RESET_MAXANISOTROPY` - Turn on/off max anisotropy.
     *    - `BGFX_RESET_CAPTURE` - Begin screen capture.
     *    - `BGFX_RESET_FLUSH_AFTER_RENDER` - Flush rendering after submitting to GPU.
     *    - `BGFX_RESET_FLIP_AFTER_RENDER` - This flag  specifies where flip
     *      occurs. Default behaviour is that flip occurs before rendering new
     *      frame. This flag only has effect when `BGFX_CONFIG_MULTITHREADED=0`.
     *    - `BGFX_RESET_SRGB_BACKBUFFER` - Enable sRGB backbuffer.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     *
     */
    reset :: proc(_width, _height, _flags: c.uint32_t, _format: texture_format_t) ---

    /**
     * Advance to next frame. When using multithreaded renderer, this call
     * just swaps internal buffers, kicks render thread, and returns. In
     * singlethreaded renderer this call does frame rendering.
     *
     * @param[in] _capture Capture frame with graphics debugger.
     *
     * @returns Current frame number. This might be used in conjunction with
     *  double/multi buffering data outside the library and passing it to
     *  library via `bgfx::makeRef` calls.
     *
     */
    frame :: proc(_capture: c.bool) -> c.uint32_t ---

    /**
     * Returns current renderer backend API type.
     * @remarks
     *   Library must be initialized.
     *
     */
    get_renderer_type :: proc() -> renderer_type_t ---

    /**
     * Returns renderer capabilities.
     * @remarks
     *   Library must be initialized.
     *
     */
    get_caps :: proc() -> ^caps_t ---

    /**
     * Returns performance counters.
     * @attention Pointer returned is valid until `bgfx::frame` is called.
     *
     */
    get_stats :: proc() -> ^stats_t ---

    /**
     * Allocate buffer to pass to bgfx calls. Data will be freed inside bgfx.
     *
     * @param[in] _size Size to allocate.
     *
     * @returns Allocated memory.
     *
     */
    alloc :: proc(_size: c.uint32_t) -> ^memory_t ---

    /**
     * Allocate buffer and copy data into it. Data will be freed inside bgfx.
     *
     * @param[in] _data Pointer to data to be copied.
     * @param[in] _size Size of data to be copied.
     *
     * @returns Allocated memory.
     *
     */
    copy :: proc(_data: rawptr, _size: c.uint32_t) -> ^memory_t ---

    /**
     * Make reference to data to pass to bgfx. Unlike `bgfx::alloc`, this call
     * doesn't allocate memory for data. It just copies the _data pointer. You
     * can pass `ReleaseFn` function pointer to release this memory after it's
     * consumed, otherwise you must make sure _data is available for at least 2
     * `bgfx::frame` calls. `ReleaseFn` function must be able to be called
     * from any thread.
     * @attention Data passed must be available for at least 2 `bgfx::frame` calls.
     *
     * @param[in] _data Pointer to data.
     * @param[in] _size Size of data.
     *
     * @returns Referenced memory.
     *
     */
    make_ref :: proc(_data: rawptr, _size: c.uint32_t) -> ^memory_t ---

    /**
     * Make reference to data to pass to bgfx. Unlike `bgfx::alloc`, this call
     * doesn't allocate memory for data. It just copies the _data pointer. You
     * can pass `ReleaseFn` function pointer to release this memory after it's
     * consumed, otherwise you must make sure _data is available for at least 2
     * `bgfx::frame` calls. `ReleaseFn` function must be able to be called
     * from any thread.
     * @attention Data passed must be available for at least 2 `bgfx::frame` calls.
     *
     * @param[in] _data Pointer to data.
     * @param[in] _size Size of data.
     * @param[in] _releaseFn Callback function to release memory after use.
     * @param[in] _userData User data to be passed to callback function.
     *
     * @returns Referenced memory.
     *
     */
    make_ref_release :: proc(_data: rawptr, _size: c.uint32_t, _releaseFn: release_fn_t, _userData: rawptr) -> ^memory_t ---

    /**
     * Set debug flags.
     *
     * @param[in] _debug Available flags:
     *    - `BGFX_DEBUG_IFH` - Infinitely fast hardware. When this flag is set
     *      all rendering calls will be skipped. This is useful when profiling
     *      to quickly assess potential bottlenecks between CPU and GPU.
     *    - `BGFX_DEBUG_PROFILER` - Enable profiler.
     *    - `BGFX_DEBUG_STATS` - Display internal statistics.
     *    - `BGFX_DEBUG_TEXT` - Display debug text.
     *    - `BGFX_DEBUG_WIREFRAME` - Wireframe rendering. All rendering
     *      primitives will be rendered as lines.
     *
     */
    set_debug :: proc(_debug: c.uint32_t) ---

    /**
     * Clear internal debug text buffer.
     *
     * @param[in] _attr Background color.
     * @param[in] _small Default 8x16 or 8x8 font.
     *
     */
    dbg_text_clear :: proc(_attr: c.uint8_t, _small: c.bool) ---

    /**
     * Print formatted data to internal debug text character-buffer (VGA-compatible text mode).
     *
     * @param[in] _x Position x from the left corner of the window.
     * @param[in] _y Position y from the top corner of the window.
     * @param[in] _attr Color palette. Where top 4-bits represent index of background, and bottom
     *  4-bits represent foreground color from standard VGA text palette (ANSI escape codes).
     * @param[in] _format `printf` style format.
     * @param[in]
     *
     */
    dbg_text_printf :: proc(_x, _y: c.uint16_t, _attr: c.uint8_t, _format: cstring, _argList: ..cstring) ---

    /**
     * Print formatted data from variable argument list to internal debug text character-buffer (VGA-compatible text mode).
     *
     * @param[in] _x Position x from the left corner of the window.
     * @param[in] _y Position y from the top corner of the window.
     * @param[in] _attr Color palette. Where top 4-bits represent index of background, and bottom
     *  4-bits represent foreground color from standard VGA text palette (ANSI escape codes).
     * @param[in] _format `printf` style format.
     * @param[in] _argList Variable arguments list for format string.
     *
     */
    dbg_text_vprintf :: proc(_x, _y: c.uint16_t, _attr: c.uint8_t, _format: cstring, _argList: ..cstring) ---

    /**
     * Draw image into internal debug text buffer.
     *
     * @param[in] _x Position x from the left corner of the window.
     * @param[in] _y Position y from the top corner of the window.
     * @param[in] _width Image width.
     * @param[in] _height Image height.
     * @param[in] _data Raw image data (character/attribute raw encoding).
     * @param[in] _pitch Image pitch in bytes.
     *
     */
    dbg_text_image :: proc(_x, _y, _width, _height: c.uint16_t, _data: rawptr, _pitch: c.uint16_t) ---

    /**
     * Create static index buffer.
     *
     * @param[in] _mem Index buffer data.
     * @param[in] _flags Buffer creation flags.
     *    - `BGFX_BUFFER_NONE` - No flags.
     *    - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
     *    - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
     *        is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
     *    - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
     *    - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
     *        data is passed. If this flag is not specified, and more data is passed on update, the buffer
     *        will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
     *        buffers.
     *    - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
     *        index buffers.
     *
     */
    create_index_buffer :: proc(_mem: ^memory_t, _flags: c.uint16_t) -> index_buffer_handle_t ---

    /**
     * Set static index buffer debug name.
     *
     * @param[in] _handle Static index buffer handle.
     * @param[in] _name Static index buffer name.
     * @param[in] _len Static index buffer name length (if length is INT32_MAX, it's expected
     *  that _name is zero terminated string.
     *
     */
    set_index_buffer_name :: proc(_handle: index_buffer_handle_t, _name: cstring, _len: c.int32_t) ---

    /**
     * Destroy static index buffer.
     *
     * @param[in] _handle Static index buffer handle.
     *
     */
    destroy_index_buffer :: proc(_handle: index_buffer_handle_t) ---

    /**
     * Create vertex layout.
     *
     * @param[in] _layout Vertex layout.
     *
     */
    create_vertex_layout :: proc(_layout: ^vertex_layout_t) -> vertex_layout_handle_t ---

    /**
     * Destroy vertex layout.
     *
     * @param[in] _layoutHandle Vertex layout handle.
     *
     */
    destroy_vertex_layout :: proc(_layoutHandle: vertex_layout_handle_t) ---

    /**
     * Create static vertex buffer.
     *
     * @param[in] _mem Vertex buffer data.
     * @param[in] _layout Vertex layout.
     * @param[in] _flags Buffer creation flags.
     *   - `BGFX_BUFFER_NONE` - No flags.
     *   - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
     *   - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
     *       is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
     *   - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
     *   - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
     *       data is passed. If this flag is not specified, and more data is passed on update, the buffer
     *       will be trimmed to fit the existing buffer size. This flag has effect only on dynamic buffers.
     *   - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on index buffers.
     *
     * @returns Static vertex buffer handle.
     *
     */
    create_vertex_buffer :: proc(_mem: ^memory_t, _layout: ^vertex_layout_t, _flags: c.uint16_t) -> vertex_buffer_handle_t ---

    /**
     * Set static vertex buffer debug name.
     *
     * @param[in] _handle Static vertex buffer handle.
     * @param[in] _name Static vertex buffer name.
     * @param[in] _len Static vertex buffer name length (if length is INT32_MAX, it's expected
     *  that _name is zero terminated string.
     *
     */
     set_vertex_buffer_name :: proc(_handle: vertex_buffer_handle_t, _name: cstring, _len: c.int32_t) ---

    /**
     * Destroy static vertex buffer.
     *
     * @param[in] _handle Static vertex buffer handle.
     *
     */
    destroy_vertex_buffer :: proc(_handle: vertex_buffer_handle_t) ---

    /**
     * Create empty dynamic index buffer.
     *
     * @param[in] _num Number of indices.
     * @param[in] _flags Buffer creation flags.
     *    - `BGFX_BUFFER_NONE` - No flags.
     *    - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
     *    - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
     *        is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
     *    - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
     *    - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
     *        data is passed. If this flag is not specified, and more data is passed on update, the buffer
     *        will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
     *        buffers.
     *    - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
     *        index buffers.
     *
     * @returns Dynamic index buffer handle.
     *
     */
    create_dynamic_index_buffer :: proc(_num: c.uint32_t, _flags: c.uint16_t) -> dynamic_index_buffer_handle_t ---

    /**
     * Create dynamic index buffer and initialized it.
     *
     * @param[in] _mem Index buffer data.
     * @param[in] _flags Buffer creation flags.
     *    - `BGFX_BUFFER_NONE` - No flags.
     *    - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
     *    - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
     *        is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
     *    - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
     *    - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
     *        data is passed. If this flag is not specified, and more data is passed on update, the buffer
     *        will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
     *        buffers.
     *    - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
     *        index buffers.
     *
     * @returns Dynamic index buffer handle.
     *
     */
    create_dynamic_index_buffer_mem :: proc(_mem: ^memory_t, _flags: c.uint16_t) -> dynamic_index_buffer_handle_t ---

    /**
     * Update dynamic index buffer.
     *
     * @param[in] _handle Dynamic index buffer handle.
     * @param[in] _startIndex Start index.
     * @param[in] _mem Index buffer data.
     *
     */
    update_dynamic_index_buffer :: proc(_handle: dynamic_index_buffer_handle_t, _startIndex: c.uint32_t, _mem: ^memory_t) ---

    /**
     * Destroy dynamic index buffer.
     *
     * @param[in] _handle Dynamic index buffer handle.
     *
     */
    destroy_dynamic_index_buffer :: proc(_handle: dynamic_index_buffer_handle_t) ---

    /**
     * Create empty dynamic vertex buffer.
     *
     * @param[in] _num Number of vertices.
     * @param[in] _layout Vertex layout.
     * @param[in] _flags Buffer creation flags.
     *    - `BGFX_BUFFER_NONE` - No flags.
     *    - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
     *    - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
     *        is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
     *    - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
     *    - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
     *        data is passed. If this flag is not specified, and more data is passed on update, the buffer
     *        will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
     *        buffers.
     *    - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
     *        index buffers.
     *
     * @returns Dynamic vertex buffer handle.
     *
     */
    create_dynamic_vertex_buffer :: proc(_num: c.uint32_t, _layout: ^vertex_layout_t, _flags: c.uint16_t) -> dynamic_vertex_buffer_handle_t ---

    /**
     * Create dynamic vertex buffer and initialize it.
     *
     * @param[in] _mem Vertex buffer data.
     * @param[in] _layout Vertex layout.
     * @param[in] _flags Buffer creation flags.
     *    - `BGFX_BUFFER_NONE` - No flags.
     *    - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
     *    - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
     *        is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
     *    - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
     *    - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
     *        data is passed. If this flag is not specified, and more data is passed on update, the buffer
     *        will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
     *        buffers.
     *    - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
     *        index buffers.
     *
     * @returns Dynamic vertex buffer handle.
     *
     */
    create_dynamic_vertex_buffer_mem :: proc(_mem: ^memory_t, _layout: ^vertex_layout_t, _flags: c.uint16_t) -> dynamic_vertex_buffer_handle_t ---

    /**
     * Update dynamic vertex buffer.
     *
     * @param[in] _handle Dynamic vertex buffer handle.
     * @param[in] _startVertex Start vertex.
     * @param[in] _mem Vertex buffer data.
     *
     */
    update_dynamic_vertex_buffer :: proc(_handle: dynamic_vertex_buffer_handle_t, _startVertex: c.uint32_t, _mem: ^memory_t) ---

    /**
     * Destroy dynamic vertex buffer.
     *
     * @param[in] _handle Dynamic vertex buffer handle.
     *
     */
    destroy_dynamic_vertex_buffer :: proc(_handle: dynamic_vertex_buffer_handle_t) ---

    /**
     * Returns number of requested or maximum available indices.
     *
     * @param[in] _num Number of required indices.
     * @param[in] _index32 Set to `true` if input indices will be 32-bit.
     *
     * @returns Number of requested or maximum available indices.
     *
     */
    get_avail_transient_index_buffer :: proc(_num: c.uint32_t, _index32: c.bool) -> c.uint32_t ---

    /**
     * Returns number of requested or maximum available vertices.
     *
     * @param[in] _num Number of required vertices.
     * @param[in] _layout Vertex layout.
     *
     * @returns Number of requested or maximum available vertices.
     *
     */
    get_avail_transient_vertex_buffer :: proc(_num: c.uint32_t, _layout: ^vertex_layout_t) -> c.uint32_t ---

    /**
     * Returns number of requested or maximum available instance buffer slots.
     *
     * @param[in] _num Number of required instances.
     * @param[in] _stride Stride per instance.
     *
     * @returns Number of requested or maximum available instance buffer slots.
     *
     */
    get_avail_instance_data_buffer :: proc(_num: c.uint32_t, _stride: ^c.uint16_t) -> c.uint32_t ---

    /**
     * Allocate transient index buffer.
     *
     * @param[out] _tib TransientIndexBuffer structure is filled and is valid
     *  for the duration of frame, and it can be reused for multiple draw
     *  calls.
     * @param[in] _num Number of indices to allocate.
     * @param[in] _index32 Set to `true` if input indices will be 32-bit.
     *
     */
    alloc_transient_index_buffer :: proc(_tib: ^transient_index_buffer_t, _num: c.uint32_t, _index32: c.bool) ---

    /**
     * Allocate transient vertex buffer.
     *
     * @param[out] _tvb TransientVertexBuffer structure is filled and is valid
     *  for the duration of frame, and it can be reused for multiple draw
     *  calls.
     * @param[in] _num Number of vertices to allocate.
     * @param[in] _layout Vertex layout.
     *
     */
    alloc_transient_vertex_buffer :: proc(_tvb: ^transient_vertex_buffer_t, _num: c.uint32_t, _layout: ^vertex_layout_t) ---

    /**
     * Check for required space and allocate transient vertex and index
     * buffers. If both space requirements are satisfied function returns
     * true.
     *
     * @param[out] _tvb TransientVertexBuffer structure is filled and is valid
     *  for the duration of frame, and it can be reused for multiple draw
     *  calls.
     * @param[in] _layout Vertex layout.
     * @param[in] _numVertices Number of vertices to allocate.
     * @param[out] _tib TransientIndexBuffer structure is filled and is valid
     *  for the duration of frame, and it can be reused for multiple draw
     *  calls.
     * @param[in] _numIndices Number of indices to allocate.
     * @param[in] _index32 Set to `true` if input indices will be 32-bit.
     *
     */
    alloc_transient_buffers :: proc(_tvb: ^transient_vertex_buffer_t, _layout: ^vertex_layout_t, _numVertices: c.uint32_t, _tib: ^transient_index_buffer_t,
                                    _numIndices: c.uint32_t, _index32: c.bool) ---

    /**
     * Allocate instance data buffer.
     *
     * @param[out] _idb InstanceDataBuffer structure is filled and is valid
     *  for duration of frame, and it can be reused for multiple draw
     *  calls.
     * @param[in] _num Number of instances.
     * @param[in] _stride Instance stride. Must be multiple of 16.
     *
     */
    alloc_instance_data_buffer :: proc(_idb: ^instance_data_buffer_t, _num: c.uint32_t, _stride: ^c.uint16_t) ---

    /**
     * Create draw indirect buffer.
     *
     * @param[in] _num Number of indirect calls.
     *
     * @returns Indirect buffer handle.
     *
     */
    create_indirect_buffer :: proc(_num: c.uint32_t) -> indirect_buffer_handle_t ---

    /**
     * Destroy draw indirect buffer.
     *
     * @param[in] _handle Indirect buffer handle.
     *
     */
    destroy_indirect_buffer :: proc(_handle: indirect_buffer_handle_t) ---

    /**
     * Create shader from memory buffer.
     *
     * @param[in] _mem Shader binary.
     *
     * @returns Shader handle.
     *
     */
    create_shader :: proc(_mem: ^memory_t) -> shader_handle_t ---

    /**
     * Returns the number of uniforms and uniform handles used inside a shader.
     * @remarks
     *   Only non-predefined uniforms are returned.
     *
     * @param[in] _handle Shader handle.
     * @param[out] _uniforms UniformHandle array where data will be stored.
     * @param[in] _max Maximum capacity of array.
     *
     * @returns Number of uniforms used by shader.
     *
     */
    get_shader_uniforms :: proc(_handle: shader_handle_t, _uniforms: ^uniform_handle_t, _max: c.uint16_t) -> c.uint16_t ---

    /**
     * Set shader debug name.
     *
     * @param[in] _handle Shader handle.
     * @param[in] _name Shader name.
     * @param[in] _len Shader name length (if length is INT32_MAX, it's expected
     *  that _name is zero terminated string).
     *
     */
    set_shader_name :: proc(_handle: shader_handle_t, _name: cstring, _len: c.int32_t) ---

    /**
     * Destroy shader.
     * @remark Once a shader program is created with _handle,
     *   it is safe to destroy that shader.
     *
     * @param[in] _handle Shader handle.
     *
     */
    destroy_shader :: proc(_handle: shader_handle_t) ---

    /**
     * Create program with vertex and fragment shaders.
     *
     * @param[in] _vsh Vertex shader.
     * @param[in] _fsh Fragment shader.
     * @param[in] _destroyShaders If true, shaders will be destroyed when program is destroyed.
     *
     * @returns Program handle if vertex shader output and fragment shader
     *  input are matching, otherwise returns invalid program handle.
     *
     */
    create_program :: proc(_vsh, _fsh: shader_handle_t, _destroyShaders: c.bool) -> program_handle_t ---

    /**
     * Create program with compute shader.
     *
     * @param[in] _csh Compute shader.
     * @param[in] _destroyShaders If true, shaders will be destroyed when program is destroyed.
     *
     * @returns Program handle.
     *
     */
    create_compute_program :: proc(_csh: shader_handle_t, _destroyShaders: c.bool) -> program_handle_t ---

    /**
     * Destroy program.
     *
     * @param[in] _handle Program handle.
     *
     */
    destroy_program :: proc(_handle: program_handle_t) ---

    /**
     * Validate texture parameters.
     *
     * @param[in] _depth Depth dimension of volume texture.
     * @param[in] _cubeMap Indicates that texture contains cubemap.
     * @param[in] _numLayers Number of layers in texture array.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     * @param[in] _flags Texture flags. See `BGFX_TEXTURE_*`.
     *
     * @returns True if texture can be successfully created.
     *
     */
    is_texture_valid :: proc(_depth: c.uint16_t, _cubeMap: c.bool, _numLayers: c.uint16_t, _format: texture_format_t, _flags: c.uint64_t) -> c.bool ---

    /**
     * Validate frame buffer parameters.
     *
     * @param[in] _num Number of attachments.
     * @param[in] _attachment Attachment texture info. See: `bgfx::Attachment`.
     *
     * @returns True if frame buffer can be successfully created.
     *
     */
    is_frame_buffer_valid :: proc(_num: c.uint8_t, _attachment: ^attachment_t) -> c.bool ---

    /**
     * Calculate amount of memory required for texture.
     *
     * @param[out] _info Resulting texture info structure. See: `TextureInfo`.
     * @param[in] _width Width.
     * @param[in] _height Height.
     * @param[in] _depth Depth dimension of volume texture.
     * @param[in] _cubeMap Indicates that texture contains cubemap.
     * @param[in] _hasMips Indicates that texture contains full mip-map chain.
     * @param[in] _numLayers Number of layers in texture array.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     *
     */
    calc_texture_size :: proc(_info: ^texture_info_t, _width, _height, _depth: c.uint16_t, _cubeMap, _hasMips: c.bool, _numLayers: c.uint16_t, _format: texture_format_t) ---

    /**
     * Create texture from memory buffer.
     *
     * @param[in] _mem DDS, KTX or PVR texture binary data.
     * @param[in] _flags Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
     *  flags. Default texture sampling mode is linear, and wrap mode is repeat.
     *  - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *    mode.
     *  - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *    sampling.
     * @param[in] _skip Skip top level mips when parsing texture.
     * @param[out] _info When non-`NULL` is specified it returns parsed texture information.
     *
     * @returns Texture handle.
     *
     */
    create_texture :: proc(_mem: ^memory_t, _flags: c.uint64_t, _skip: c.uint8_t, _info: ^texture_info_t) -> texture_handle_t ---

    /**
     * Create 2D texture.
     *
     * @param[in] _width Width.
     * @param[in] _height Height.
     * @param[in] _hasMips Indicates that texture contains full mip-map chain.
     * @param[in] _numLayers Number of layers in texture array. Must be 1 if caps
     *  `BGFX_CAPS_TEXTURE_2D_ARRAY` flag is not set.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     * @param[in] _flags Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
     *  flags. Default texture sampling mode is linear, and wrap mode is repeat.
     *  - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *    mode.
     *  - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *    sampling.
     * @param[in] _mem Texture data. If `_mem` is non-NULL, created texture will be immutable. If
     *  `_mem` is NULL content of the texture is uninitialized. When `_numLayers` is more than
     *  1, expected memory layout is texture and all mips together for each array element.
     *
     * @returns Texture handle.
     *
     */
    create_texture_2d :: proc(_width, _height, _depth: c.uint16_t, _hasMips: c.bool, _numLayers: c.uint16_t, _format: texture_format_t, flags: c.uint64_t, _mem: ^memory_t) -> texture_handle_t ---
    
    /**
     * Create texture with size based on backbuffer ratio. Texture will maintain ratio
     * if back buffer resolution changes.
     *
     * @param[in] _ratio Texture size in respect to back-buffer size. See: `BackbufferRatio::Enum`.
     * @param[in] _hasMips Indicates that texture contains full mip-map chain.
     * @param[in] _numLayers Number of layers in texture array. Must be 1 if caps
     *  `BGFX_CAPS_TEXTURE_2D_ARRAY` flag is not set.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     * @param[in] _flags Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
     *  flags. Default texture sampling mode is linear, and wrap mode is repeat.
     *  - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *    mode.
     *  - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *    sampling.
     *
     * @returns Texture handle.
     *
     */
    create_texture_2d_scaled :: proc(_ratio: backbuffer_ratio_t, _hasMips: c.bool, _numLayers: c.uint16_t, _format: texture_format_t, flags: c.uint64_t) -> texture_handle_t ---

    /**
     * Create 3D texture.
     *
     * @param[in] _width Width.
     * @param[in] _height Height.
     * @param[in] _depth Depth.
     * @param[in] _hasMips Indicates that texture contains full mip-map chain.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     * @param[in] _flags Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
     *  flags. Default texture sampling mode is linear, and wrap mode is repeat.
     *  - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *    mode.
     *  - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *    sampling.
     * @param[in] _mem Texture data. If `_mem` is non-NULL, created texture will be immutable. If
     *  `_mem` is NULL content of the texture is uninitialized. When `_numLayers` is more than
     *  1, expected memory layout is texture and all mips together for each array element.
     *
     * @returns Texture handle.
     *
     */
    create_texture_3d :: proc(_width, _height, _depth: c.uint16_t, _hasMips: c.bool, _numLayers: c.uint16_t, _format: texture_format_t, flags: c.uint64_t, _mem: ^memory_t) -> texture_handle_t ---

    /**
     * Create Cube texture.
     *
     * @param[in] _size Cube side size.
     * @param[in] _hasMips Indicates that texture contains full mip-map chain.
     * @param[in] _numLayers Number of layers in texture array. Must be 1 if caps
     *  `BGFX_CAPS_TEXTURE_2D_ARRAY` flag is not set.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     * @param[in] _flags Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
     *  flags. Default texture sampling mode is linear, and wrap mode is repeat.
     *  - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *    mode.
     *  - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *    sampling.
     * @param[in] _mem Texture data. If `_mem` is non-NULL, created texture will be immutable. If
     *  `_mem` is NULL content of the texture is uninitialized. When `_numLayers` is more than
     *  1, expected memory layout is texture and all mips together for each array element.
     *
     * @returns Texture handle.
     *
     */
    create_texture_cube :: proc(_size: c.uint16_t, _hasMips: c.bool, _numLayers: c.uint16_t, _format: texture_format_t, flags: c.uint64_t, _mem: ^memory_t) -> texture_handle_t ---

    /**
     * Update 2D texture.
     * @attention It's valid to update only mutable texture. See `bgfx::createTexture2D` for more info.
     *
     * @param[in] _handle Texture handle.
     * @param[in] _layer Layer in texture array.
     * @param[in] _mip Mip level.
     * @param[in] _x X offset in texture.
     * @param[in] _y Y offset in texture.
     * @param[in] _width Width of texture block.
     * @param[in] _height Height of texture block.
     * @param[in] _mem Texture update data.
     * @param[in] _pitch Pitch of input image (bytes). When _pitch is set to
     *  UINT16_MAX, it will be calculated internally based on _width.
     *
     */
    update_texture_2d :: proc(_handle: texture_handle_t, _layer: c.uint16_t, _mip: c.uint8_t, _x, _y, _width, _height: c.uint16_t, _mem: ^memory_t, _pitch: c.uint16_t) ---

    /**
     * Update 3D texture.
     * @attention It's valid to update only mutable texture. See `bgfx::createTexture3D` for more info.
     *
     * @param[in] _handle Texture handle.
     * @param[in] _mip Mip level.
     * @param[in] _x X offset in texture.
     * @param[in] _y Y offset in texture.
     * @param[in] _z Z offset in texture.
     * @param[in] _width Width of texture block.
     * @param[in] _height Height of texture block.
     * @param[in] _depth Depth of texture block.
     * @param[in] _mem Texture update data.
     *
     */
     update_texture_3d :: proc(_handle: texture_handle_t, _layer: c.uint16_t, _mip: c.uint8_t, _x, _y, _z, _width, _height, _depth: c.uint16_t, _mem: ^memory_t) ---

    /**
     * Update Cube texture.
     * @attention It's valid to update only mutable texture. See `bgfx::createTextureCube` for more info.
     *
     * @param[in] _handle Texture handle.
     * @param[in] _layer Layer in texture array.
     * @param[in] _side Cubemap side `BGFX_CUBE_MAP_<POSITIVE or NEGATIVE>_<X, Y or Z>`,
     *    where 0 is +X, 1 is -X, 2 is +Y, 3 is -Y, 4 is +Z, and 5 is -Z.
     *                   +----------+
     *                   |-z       2|
     *                   | ^  +y    |
     *                   | |        |    Unfolded cube:
     *                   | +---->+x |
     *        +----------+----------+----------+----------+
     *        |+y       1|+y       4|+y       0|+y       5|
     *        | ^  -x    | ^  +z    | ^  +x    | ^  -z    |
     *        | |        | |        | |        | |        |
     *        | +---->+z | +---->+x | +---->-z | +---->-x |
     *        +----------+----------+----------+----------+
     *                   |+z       3|
     *                   | ^  -y    |
     *                   | |        |
     *                   | +---->+x |
     *                   +----------+
     * @param[in] _mip Mip level.
     * @param[in] _x X offset in texture.
     * @param[in] _y Y offset in texture.
     * @param[in] _width Width of texture block.
     * @param[in] _height Height of texture block.
     * @param[in] _mem Texture update data.
     * @param[in] _pitch Pitch of input image (bytes). When _pitch is set to
     *  UINT16_MAX, it will be calculated internally based on _width.
     *
     */
    update_texture_cube :: proc(_handle: texture_handle_t, _layer: c.uint16_t, _side, _mip: c.uint8_t, _x, _y, _width, _height: c.uint16_t, _mem: ^memory_t, _pitch: c.uint16_t) ---

    /**
     * Read back texture content.
     * @attention Texture must be created with `BGFX_TEXTURE_READ_BACK` flag.
     * @attention Availability depends on: `BGFX_CAPS_TEXTURE_READ_BACK`.
     *
     * @param[in] _handle Texture handle.
     * @param[in] _data Destination buffer.
     * @param[in] _mip Mip level.
     *
     * @returns Frame number when the result will be available. See: `bgfx::frame`.
     *
     */
    read_texture :: proc(_handle: texture_handle_t, _data: rawptr, _mip: c.uint8_t) -> c.uint32_t ---

    /**
     * Set texture debug name.
     *
     * @param[in] _handle Texture handle.
     * @param[in] _name Texture name.
     * @param[in] _len Texture name length (if length is INT32_MAX, it's expected
     *  that _name is zero terminated string.
     *
     */
    set_texture_name :: proc(_handle: texture_handle_t, _name: cstring, _len: c.uint32_t) ---

    /**
     * Returns texture direct access pointer.
     * @attention Availability depends on: `BGFX_CAPS_TEXTURE_DIRECT_ACCESS`. This feature
     *   is available on GPUs that have unified memory architecture (UMA) support.
     *
     * @param[in] _handle Texture handle.
     *
     * @returns Pointer to texture memory. If returned pointer is `NULL` direct access
     *  is not available for this texture. If pointer is `UINTPTR_MAX` sentinel value
     *  it means texture is pending creation. Pointer returned can be cached and it
     *  will be valid until texture is destroyed.
     *
     */
    get_direct_access_ptr :: proc(_handle: texture_handle_t) -> rawptr ---

    /**
     * Destroy texture.
     *
     * @param[in] _handle Texture handle.
     *
     */
    destroy_texture :: proc(_handle: texture_handle_t) ---

    /**
     * Create frame buffer (simple).
     *
     * @param[in] _width Texture width.
     * @param[in] _height Texture height.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     * @param[in] _textureFlags Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
     *  flags. Default texture sampling mode is linear, and wrap mode is repeat.
     *  - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *    mode.
     *  - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *    sampling.
     *
     * @returns Frame buffer handle.
     *
     */
    create_frame_buffer :: proc(_width, _height: c.uint16_t, _format: texture_format_t, _textureFlags: c.uint64_t) -> frame_buffer_handle_t ---

    /**
     * Create frame buffer with size based on backbuffer ratio. Frame buffer will maintain ratio
     * if back buffer resolution changes.
     *
     * @param[in] _ratio Frame buffer size in respect to back-buffer size. See:
     *  `BackbufferRatio::Enum`.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     * @param[in] _textureFlags Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
     *  flags. Default texture sampling mode is linear, and wrap mode is repeat.
     *  - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *    mode.
     *  - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *    sampling.
     *
     * @returns Frame buffer handle.
     *
     */
    create_frame_buffer_scaled :: proc(_ratio: backbuffer_ratio_t, _format: texture_format_t, _textureFlags: c.uint64_t) -> frame_buffer_handle_t ---

    /**
     * Create MRT frame buffer from texture handles (simple).
     *
     * @param[in] _num Number of texture handles.
     * @param[in] _handles Texture attachments.
     * @param[in] _destroyTexture If true, textures will be destroyed when
     *  frame buffer is destroyed.
     *
     * @returns Frame buffer handle.
     *
     */
    create_frame_buffer_from_handles :: proc(_num: c.uint8_t, _handles: ^texture_handle_t, _destroyTexture: c.bool) -> frame_buffer_handle_t ---

    /**
     * Create MRT frame buffer from texture handles with specific layer and
     * mip level.
     *
     * @param[in] _num Number of attachments.
     * @param[in] _attachment Attachment texture info. See: `bgfx::Attachment`.
     * @param[in] _destroyTexture If true, textures will be destroyed when
     *  frame buffer is destroyed.
     *
     * @returns Frame buffer handle.
     *
     */
    create_frame_buffer_from_attachment :: proc(_num: c.uint8_t, _attachment: ^attachment_t, _destroyTexture: c.bool) -> frame_buffer_handle_t ---

    /**
     * Create frame buffer for multiple window rendering.
     * @remarks
     *   Frame buffer cannot be used for sampling.
     * @attention Availability depends on: `BGFX_CAPS_SWAP_CHAIN`.
     *
     * @param[in] _nwh OS' target native window handle.
     * @param[in] _width Window back buffer width.
     * @param[in] _height Window back buffer height.
     * @param[in] _format Window back buffer color format.
     * @param[in] _depthFormat Window back buffer depth format.
     *
     * @returns Frame buffer handle.
     *
     */
    create_frame_buffer_from_nwh :: proc(_nwh: rawptr, _width, _height: c.uint16_t, _format, _depthFormat: texture_format_t) -> frame_buffer_handle_t ---

    /**
     * Set frame buffer debug name.
     *
     * @param[in] _handle Frame buffer handle.
     * @param[in] _name Frame buffer name.
     * @param[in] _len Frame buffer name length (if length is INT32_MAX, it's expected
     *  that _name is zero terminated string.
     *
     */
    set_frame_buffer_name :: proc(_handle: frame_buffer_handle_t, _name: cstring, _len: c.int32_t) ---

    /**
     * Obtain texture handle of frame buffer attachment.
     *
     * @param[in] _handle Frame buffer handle.
     * @param[in] _attachment
     *
     */
    get_texture :: proc(_handle: frame_buffer_handle_t, _attachment: c.int8_t) -> texture_handle_t ---

    /**
     * Destroy frame buffer.
     *
     * @param[in] _handle Frame buffer handle.
     *
     */
    destroy_frame_buffer :: proc(_handle: frame_buffer_handle_t) ---

    /**
     * Create shader uniform parameter.
     * @remarks
     *   1. Uniform names are unique. It's valid to call `bgfx::createUniform`
     *      multiple times with the same uniform name. The library will always
     *      return the same handle, but the handle reference count will be
     *      incremented. This means that the same number of `bgfx::destroyUniform`
     *      must be called to properly destroy the uniform.
     *   2. Predefined uniforms (declared in `bgfx_shader.sh`):
     *      - `u_viewRect vec4(x, y, width, height)` - view rectangle for current
     *        view, in pixels.
     *      - `u_viewTexel vec4(1.0/width, 1.0/height, undef, undef)` - inverse
     *        width and height
     *      - `u_view mat4` - view matrix
     *      - `u_invView mat4` - inverted view matrix
     *      - `u_proj mat4` - projection matrix
     *      - `u_invProj mat4` - inverted projection matrix
     *      - `u_viewProj mat4` - concatenated view projection matrix
     *      - `u_invViewProj mat4` - concatenated inverted view projection matrix
     *      - `u_model mat4[BGFX_CONFIG_MAX_BONES]` - array of model matrices.
     *      - `u_modelView mat4` - concatenated model view matrix, only first
     *        model matrix from array is used.
     *      - `u_modelViewProj mat4` - concatenated model view projection matrix.
     *      - `u_alphaRef float` - alpha reference value for alpha test.
     *
     * @param[in] _name Uniform name in shader.
     * @param[in] _type Type of uniform (See: `bgfx::UniformType`).
     * @param[in] _num Number of elements in array.
     *
     * @returns Handle to uniform object.
     *
     */
    create_uniform :: proc(_name: cstring, _type: uniform_type_t, _num: c.uint16_t) -> uniform_handle_t ---

    /**
     * Retrieve uniform info.
     *
     * @param[in] _handle Handle to uniform object.
     * @param[out] _info Uniform info.
     *
     */
    get_uniform_info :: proc(_handle: uniform_handle_t, _info: ^uniform_info_t) ---

    /**
     * Destroy shader uniform parameter.
     *
     * @param[in] _handle Handle to uniform object.
     *
     */
    destroy_uniform :: proc(_handle: uniform_handle_t) ---

    /**
     * Create occlusion query.
     *
     */
    create_occlusion_query :: proc() -> occlusion_query_handle_t ---

    /**
     * Retrieve occlusion query result from previous frame.
     *
     * @param[in] _handle Handle to occlusion query object.
     * @param[out] _result Number of pixels that passed test. This argument
     *  can be `NULL` if result of occlusion query is not needed.
     *
     * @returns Occlusion query result.
     *
     */
    get_result :: proc(_handle: occlusion_query_handle_t, _result: ^c.int32_t) -> occlusion_query_result_t ---

    /**
     * Destroy occlusion query.
     *
     * @param[in] _handle Handle to occlusion query object.
     *
     */
    destroy_occlusion_query :: proc(_handle: occlusion_query_handle_t) ---

    /**
     * Set palette color value.
     *
     * @param[in] _index Index into palette.
     * @param[in] _rgba RGBA floating point values.
     *
     */
    set_palette_color :: proc(_index: c.uint8_t, _rgba: [4]c.float) ---

    /**
     * Set palette color value.
     *
     * @param[in] _index Index into palette.
     * @param[in] _rgba Packed 32-bit RGBA value.
     *
     */
    set_palette_color_rgba8 :: proc(_index: c.uint8_t, _rgba: c.uint32_t) ---

    /**
     * Set view name.
     * @remarks
     *   This is debug only feature.
     *   In graphics debugger view name will appear as:
     *       "nnnc <view name>"
     *        ^  ^ ^
     *        |  +--- compute (C)
     *        +------ view id
     *
     * @param[in] _id View id.
     * @param[in] _name View name.
     *
     */
    set_view_name :: proc(_id: view_id_t, _name: cstring) ---

    /**
     * Set view rectangle. Draw primitive outside view will be clipped.
     *
     * @param[in] _id View id.
     * @param[in] _x Position x from the left corner of the window.
     * @param[in] _y Position y from the top corner of the window.
     * @param[in] _width Width of view port region.
     * @param[in] _height Height of view port region.
     *
     */
    set_view_rect :: proc(_id: view_id_t, _x, _y, _width, _height: c.uint16_t) ---

    /**
     * Set view rectangle. Draw primitive outside view will be clipped.
     *
     * @param[in] _id View id.
     * @param[in] _x Position x from the left corner of the window.
     * @param[in] _y Position y from the top corner of the window.
     * @param[in] _ratio Width and height will be set in respect to back-buffer size.
     *  See: `BackbufferRatio::Enum`.
     *
     */
    set_view_rect_ratio :: proc(_id: view_id_t, _x, _y: c.uint16_t, _ratio: backbuffer_ratio_t) ---

    /**
     * Set view scissor. Draw primitive outside view will be clipped. When
     * _x, _y, _width and _height are set to 0, scissor will be disabled.
     *
     * @param[in] _id View id.
     * @param[in] _x Position x from the left corner of the window.
     * @param[in] _y Position y from the top corner of the window.
     * @param[in] _width Width of view scissor region.
     * @param[in] _height Height of view scissor region.
     *
     */
    set_view_scissor :: proc(_id: view_id_t, _x, _y, _width, _height: c.uint16_t) ---

    /**
     * Set view clear flags.
     *
     * @param[in] _id View id.
     * @param[in] _flags Clear flags. Use `BGFX_CLEAR_NONE` to remove any clear
     *  operation. See: `BGFX_CLEAR_*`.
     * @param[in] _rgba Color clear value.
     * @param[in] _depth Depth clear value.
     * @param[in] _stencil Stencil clear value.
     *
     */
    set_view_clear :: proc(_id: view_id_t, _flags: c.uint16_t, _rgba: c.uint32_t, _depth: c.float, _stencil: c.uint8_t) ---

    /**
     * Set view clear flags with different clear color for each
     * frame buffer texture. Must use `bgfx::setPaletteColor` to setup clear color
     * palette.
     *
     * @param[in] _id View id.
     * @param[in] _flags Clear flags. Use `BGFX_CLEAR_NONE` to remove any clear
     *  operation. See: `BGFX_CLEAR_*`.
     * @param[in] _depth Depth clear value.
     * @param[in] _stencil Stencil clear value.
     * @param[in] _c0 Palette index for frame buffer attachment 0.
     * @param[in] _c1 Palette index for frame buffer attachment 1.
     * @param[in] _c2 Palette index for frame buffer attachment 2.
     * @param[in] _c3 Palette index for frame buffer attachment 3.
     * @param[in] _c4 Palette index for frame buffer attachment 4.
     * @param[in] _c5 Palette index for frame buffer attachment 5.
     * @param[in] _c6 Palette index for frame buffer attachment 6.
     * @param[in] _c7 Palette index for frame buffer attachment 7.
     *
     */
     set_view_clear_mrt :: proc(_id: view_id_t, _flags: c.uint16_t, _rgba: c.uint32_t, _depth: c.float, _stencil, _c0, _c1, _c2, _c3, _c4, _c5, _c6, _c7: c.uint8_t) ---

    /**
     * Set view sorting mode.
     * @remarks
     *   View mode must be set prior calling `bgfx::submit` for the view.
     *
     * @param[in] _id View id.
     * @param[in] _mode View sort mode. See `ViewMode::Enum`.
     *
     */
    set_view_mode :: proc(_id: view_id_t, _mode: view_mode_t) ---

    /**
     * Set view frame buffer.
     * @remarks
     *   Not persistent after `bgfx::reset` call.
     *
     * @param[in] _id View id.
     * @param[in] _handle Frame buffer handle. Passing `BGFX_INVALID_HANDLE` as
     *  frame buffer handle will draw primitives from this view into
     *  default back buffer.
     *
     */
    set_view_frame_buffer :: proc(_id: view_id_t, _handle: frame_buffer_handle_t) ---

    /**
     * Set view view and projection matrices, all draw primitives in this
     * view will use these matrices.
     *
     * @param[in] _id View id.
     * @param[in] _view View matrix.
     * @param[in] _proj Projection matrix.
     *
     */
    set_view_transform :: proc(_id: view_id_t, _view, _proj: rawptr) ---

    /**
     * Post submit view reordering.
     *
     * @param[in] _id First view id.
     * @param[in] _num Number of views to remap.
     * @param[in] _order View remap id table. Passing `NULL` will reset view ids
     *  to default state.
     *
     */
    set_view_order :: proc(_id: view_id_t, _num: c.uint16_t, _order: ^view_id_t) ---

    /**
     * Reset all view settings to default.
     *
     * @param[in] _id
     *
     */
    reset_view :: proc(_id: view_id_t) ---

    /**
     * Begin submitting draw calls from thread.
     *
     * @param[in] _forThread Explicitly request an encoder for a worker thread.
     *
     * @returns Encoder.
     *
     */
    encoder_begin :: proc(_forThread: c.bool) -> ^encoder_t ---

    /**
     * End submitting draw calls from thread.
     *
     * @param[in] _encoder Encoder.
     *
     */
    encoder_end :: proc(_encoder: ^encoder_t) ---

    /**
     * Sets a debug marker. This allows you to group graphics calls together for easy browsing in
     * graphics debugging tools.
     *
     * @param[in] _marker Marker string.
     *
     */
    encoder_set_marker :: proc(_this: ^encoder_t, _marker: cstring) ---

    /**
     * Set render states for draw primitive.
     * @remarks
     *   1. To setup more complex states use:
     *      `BGFX_STATE_ALPHA_REF(_ref)`,
     *      `BGFX_STATE_POINT_SIZE(_size)`,
     *      `BGFX_STATE_BLEND_FUNC(_src, _dst)`,
     *      `BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA)`,
     *      `BGFX_STATE_BLEND_EQUATION(_equation)`,
     *      `BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA)`
     *   2. `BGFX_STATE_BLEND_EQUATION_ADD` is set when no other blend
     *      equation is specified.
     *
     * @param[in] _state State flags. Default state for primitive type is
     *    triangles. See: `BGFX_STATE_DEFAULT`.
     *    - `BGFX_STATE_DEPTH_TEST_*` - Depth test function.
     *    - `BGFX_STATE_BLEND_*` - See remark 1 about BGFX_STATE_BLEND_FUNC.
     *    - `BGFX_STATE_BLEND_EQUATION_*` - See remark 2.
     *    - `BGFX_STATE_CULL_*` - Backface culling mode.
     *    - `BGFX_STATE_WRITE_*` - Enable R, G, B, A or Z write.
     *    - `BGFX_STATE_MSAA` - Enable hardware multisample antialiasing.
     *    - `BGFX_STATE_PT_[TRISTRIP/LINES/POINTS]` - Primitive type.
     * @param[in] _rgba Sets blend factor used by `BGFX_STATE_BLEND_FACTOR` and
     *    `BGFX_STATE_BLEND_INV_FACTOR` blend modes.
     *
     */
    encoder_set_state :: proc(_this: ^encoder_t, _state: c.uint64_t, _rgba: c.uint32_t) ---

    /**
     * Set condition for rendering.
     *
     * @param[in] _handle Occlusion query handle.
     * @param[in] _visible Render if occlusion query is visible.
     *
     */
    encoder_set_condition :: proc(_this: ^encoder_t, _handle: occlusion_query_handle_t, _visible: c.bool) ---

    /**
     * Set stencil test state.
     *
     * @param[in] _fstencil Front stencil state.
     * @param[in] _bstencil Back stencil state. If back is set to `BGFX_STENCIL_NONE`
     *  _fstencil is applied to both front and back facing primitives.
     *
     */
    encoder_set_stencil :: proc(_this: ^encoder_t, _fstencil, _bstencil: c.uint32_t) ---

    /**
     * Set scissor for draw primitive.
     * @remark
     *   To scissor for all primitives in view see `bgfx::setViewScissor`.
     *
     * @param[in] _x Position x from the left corner of the window.
     * @param[in] _y Position y from the top corner of the window.
     * @param[in] _width Width of view scissor region.
     * @param[in] _height Height of view scissor region.
     *
     * @returns Scissor cache index.
     *
     */
    encoder_set_scissor :: proc(_this: ^encoder_t, _x, _y, _width, _height: c.uint16_t) -> c.uint16_t ---

    /**
     * Set scissor from cache for draw primitive.
     * @remark
     *   To scissor for all primitives in view see `bgfx::setViewScissor`.
     *
     * @param[in] _cache Index in scissor cache.
     *
     */
    encoder_set_scissor_cached :: proc(_this: ^encoder_t, _cache: c.uint16_t) ---

    /**
     * Set model matrix for draw primitive. If it is not called,
     * the model will be rendered with an identity model matrix.
     *
     * @param[in] _mtx Pointer to first matrix in array.
     * @param[in] _num Number of matrices in array.
     *
     * @returns Index into matrix cache in case the same model matrix has
     *  to be used for other draw primitive call.
     *
     */
    encoder_set_transform :: proc(_this: ^encoder_t, _mtx: rawptr, _num: c.uint16_t) -> c.uint32_t ---

    /**
     *  Set model matrix from matrix cache for draw primitive.
     *
     * @param[in] _cache Index in matrix cache.
     * @param[in] _num Number of matrices from cache.
     *
     */
    encoder_set_transform_cached :: proc(_this: ^encoder_t, _cache: c.uint32_t, _num: c.uint16_t) ---

    /**
     * Reserve matrices in internal matrix cache.
     * @attention Pointer returned can be modifed until `bgfx::frame` is called.
     *
     * @param[out] _transform Pointer to `Transform` structure.
     * @param[in] _num Number of matrices.
     *
     * @returns Index in matrix cache.
     *
     */
    encoder_alloc_transform :: proc(_this: ^encoder_t, _transform: ^transform_t, _num: c.uint16_t) -> c.uint32_t ---

    /**
     * Set shader uniform parameter for draw primitive.
     *
     * @param[in] _handle Uniform.
     * @param[in] _value Pointer to uniform data.
     * @param[in] _num Number of elements. Passing `UINT16_MAX` will
     *  use the _num passed on uniform creation.
     *
     */
    encoder_set_uniform :: proc(_this: ^encoder_t, _handle: uniform_handle_t, _value: rawptr, _num: c.uint16_t) ---

    /**
     * Set index buffer for draw primitive.
     *
     * @param[in] _handle Index buffer.
     * @param[in] _firstIndex First index to render.
     * @param[in] _numIndices Number of indices to render.
     *
     */
    encoder_set_index_buffer :: proc(_this: ^encoder_t, _handle: index_buffer_handle_t, _firstIndex, _numIndices: c.uint32_t) ---

    /**
     * Set index buffer for draw primitive.
     *
     * @param[in] _handle Dynamic index buffer.
     * @param[in] _firstIndex First index to render.
     * @param[in] _numIndices Number of indices to render.
     *
     */
    encoder_set_dynamic_index_buffer :: proc(_this: ^encoder_t, _handle: dynamic_index_buffer_handle_t, _firstIndex, _numIndices: c.uint32_t) ---

    /**
     * Set index buffer for draw primitive.
     *
     * @param[in] _tib Transient index buffer.
     * @param[in] _firstIndex First index to render.
     * @param[in] _numIndices Number of indices to render.
     *
     */
    encoder_set_transient_index_buffer :: proc(_this: ^encoder_t, _tib: ^transient_index_buffer_t, _firstIndex, _numIndices: c.uint32_t) ---

    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _handle Vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     *
     */
    encoder_set_vertex_buffer :: proc(_this: ^encoder_t, _stream: c.uint8_t, _handle: vertex_buffer_handle_t, _startVertex, _numVertices: c.uint32_t) ---

    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _handle Vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     * @param[in] _layoutHandle Vertex layout for aliasing vertex buffer. If invalid
     *  handle is used, vertex layout used for creation
     *  of vertex buffer will be used.
     *
     */
    encoder_set_vertex_buffer_with_layout :: proc(_this: ^encoder_t, _stream: c.uint8_t, _handle: vertex_buffer_handle_t, _startVertex, _numVertices: c.uint32_t,
                                                  _layoutHandle: vertex_layout_handle_t) ---
    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _handle Dynamic vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     *
     */
    encoder_set_dynamic_vertex_buffer             :: proc(_this: ^encoder_t, _stream: c.uint8_t, _handle: dynamic_vertex_buffer_handle_t, _startVertex, _numVertices: c.uint32_t) ---
    encoder_set_dynamic_vertex_buffer_with_layout :: proc(_this: ^encoder_t, _stream: c.uint8_t, _handle: dynamic_vertex_buffer_handle_t, _startVertex, _numVertices: c.uint32_t,
                                                          _layoutHandle: vertex_layout_handle_t) ---

    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _tvb Transient vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     *
     */
    encoder_set_transient_vertex_buffer :: proc(_this: ^encoder_t, _stream: c.uint8_t, _tvb: transient_vertex_buffer_t, _startVertex, _numVertices: c.uint32_t) ---

    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _tvb Transient vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     * @param[in] _layoutHandle Vertex layout for aliasing vertex buffer. If invalid
     *  handle is used, vertex layout used for creation
     *  of vertex buffer will be used.
     *
     */
    encoder_set_transient_vertex_buffer_with_layout :: proc(_this: ^encoder_t, _stream: c.uint8_t, _tvb: transient_vertex_buffer_t, _startVertex, _numVertices: c.uint32_t,
                                                            _layoutHandle: vertex_layout_handle_t) ---
    /**
     * Set number of vertices for auto generated vertices use in conjuction
     * with gl_VertexID.
     * @attention Availability depends on: `BGFX_CAPS_VERTEX_ID`.
     *
     * @param[in] _numVertices Number of vertices.
     *
     */
    encoder_set_vertex_count :: proc(_this: ^encoder_t, _numVertices: c.uint32_t) ---

    /**
     * Set instance data buffer for draw primitive.
     *
     * @param[in] _idb Transient instance data buffer.
     * @param[in] _start First instance data.
     * @param[in] _num Number of data instances.
     *
     */
    encoder_set_instance_data_buffer :: proc(_this: ^encoder_t, _idb: ^instance_data_buffer_t, _start, _num: c.uint32_t) ---

    /**
     * Set instance data buffer for draw primitive.
     *
     * @param[in] _handle Vertex buffer.
     * @param[in] _startVertex First instance data.
     * @param[in] _num Number of data instances.
     *  Set instance data buffer for draw primitive.
     *
     */
    encoder_set_instance_data_from_vertex_buffer :: proc(_this: ^encoder_t, _handle: vertex_buffer_handle_t, _startVertex, _num: c.uint32_t) ---

    /**
     * Set instance data buffer for draw primitive.
     *
     * @param[in] _handle Dynamic vertex buffer.
     * @param[in] _startVertex First instance data.
     * @param[in] _num Number of data instances.
     *
     */
    encoder_set_instance_data_from_dynamic_vertex_buffer :: proc(_this: ^encoder_t, _handle: dynamic_vertex_buffer_handle_t, _startVertex, _num: c.uint32_t) ---

    /**
     * Set number of instances for auto generated instances use in conjuction
     * with gl_InstanceID.
     * @attention Availability depends on: `BGFX_CAPS_VERTEX_ID`.
     *
     * @param[in] _numInstances
     *
     */
    encoder_set_instance_count :: proc(_this: ^encoder_t, _numInstances: c.uint32_t) ---

    /**
     * Set texture stage for draw primitive.
     *
     * @param[in] _stage Texture unit.
     * @param[in] _sampler Program sampler.
     * @param[in] _handle Texture handle.
     * @param[in] _flags Texture sampling mode. Default value UINT32_MAX uses
     *    texture sampling settings from the texture.
     *    - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *      mode.
     *    - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *      sampling.
     *
     */
    encoder_set_texture :: proc(_this: ^encoder_t, _stage: c.uint8_t, _sampler: uniform_handle_t, _handle: texture_handle_t, _flags: c.uint32_t) ---

    /**
     * Submit an empty primitive for rendering. Uniforms and draw state
     * will be applied but no geometry will be submitted. Useful in cases
     * when no other draw/compute primitive is submitted to view, but it's
     * desired to execute clear view.
     * @remark
     *   These empty draw calls will sort before ordinary draw calls.
     *
     * @param[in] _id View id.
     *
     */
    encoder_touch :: proc(_this: ^encoder_t, _id: view_id_t) ---

    /**
     * Submit primitive for rendering.
     *
     * @param[in] _id View id.
     * @param[in] _program Program.
     * @param[in] _depth Depth for sorting.
     * @param[in] _flags Discard or preserve states. See `BGFX_DISCARD_*`.
     *
     */
    encoder_submit :: proc(_this: ^encoder_t, _id: view_id_t, _program: program_handle_t, _depth: c.uint32_t, _flags: c.uint8_t) ---

    /**
     * Submit primitive with occlusion query for rendering.
     *
     * @param[in] _id View id.
     * @param[in] _program Program.
     * @param[in] _occlusionQuery Occlusion query.
     * @param[in] _depth Depth for sorting.
     * @param[in] _flags Discard or preserve states. See `BGFX_DISCARD_*`.
     *
     */
     encoder_submit_occlusion_query :: proc(_this: ^encoder_t, _id: view_id_t, _program: program_handle_t, _occlusionQuery: occlusion_query_handle_t,
                                            _depth: c.uint32_t, _flags: c.uint8_t) ---

    /**
     * Submit primitive for rendering with index and instance data info from
     * indirect buffer.
     *
     * @param[in] _id View id.
     * @param[in] _program Program.
     * @param[in] _indirectHandle Indirect buffer.
     * @param[in] _start First element in indirect buffer.
     * @param[in] _num Number of dispatches.
     * @param[in] _depth Depth for sorting.
     * @param[in] _flags Discard or preserve states. See `BGFX_DISCARD_*`.
     *
     */
    encoder_submit_indirect :: proc(_this: ^encoder_t, _id: view_id_t, _program: program_handle_t, _indirectHandle: indirect_buffer_handle_t, _start, _num: c.uint16_t, _depth: c.uint32_t, _flags: c.uint8_t) ---
    
    /**
     * Set compute index buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Index buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    encoder_set_compute_index_buffer :: proc(_this: ^encoder_t, _stage: c.uint8_t, _handle: index_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute vertex buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Vertex buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    encoder_set_compute_vertex_buffer :: proc(_this: ^encoder_t, _stage: c.uint8_t, _handle: vertex_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute dynamic index buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Dynamic index buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    encoder_set_compute_dynamic_index_buffer :: proc(_this: ^encoder_t, _stage: c.uint8_t, _handle: dynamic_index_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute dynamic vertex buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Dynamic vertex buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    encoder_set_compute_dynamic_vertex_buffer :: proc(_this: ^encoder_t, _stage: c.uint8_t, _handle: dynamic_index_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute indirect buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Indirect buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    encoder_set_compute_indirect_buffer :: proc(_this: ^encoder_t, _stage: c.uint8_t, _handle: indirect_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute image from texture.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Texture handle.
     * @param[in] _mip Mip level.
     * @param[in] _access Image access. See `Access::Enum`.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     *
     */
    encoder_set_image :: proc(_this: ^encoder_t, _stage: c.uint8_t, _handle: texture_handle_t, _mip: c.uint8_t, _access: access_t, _format: texture_format_t) ---

    /**
     * Dispatch compute.
     *
     * @param[in] _id View id.
     * @param[in] _program Compute program.
     * @param[in] _numX Number of groups X.
     * @param[in] _numY Number of groups Y.
     * @param[in] _numZ Number of groups Z.
     * @param[in] _flags Discard or preserve states. See `BGFX_DISCARD_*`.
     *
     */
    encoder_dispatch :: proc(_this: ^encoder_t, _id: view_id_t, _program: program_handle_t, _numX, _numY, _numZ: c.uint32_t, _flags: c.uint8_t) ---

    /**
     * Dispatch compute indirect.
     *
     * @param[in] _id View id.
     * @param[in] _program Compute program.
     * @param[in] _indirectHandle Indirect buffer.
     * @param[in] _start First element in indirect buffer.
     * @param[in] _num Number of dispatches.
     * @param[in] _flags Discard or preserve states. See `BGFX_DISCARD_*`.
     *
     */
    encoder_dispatch_indirect :: proc(_this: ^encoder_t, _id: view_id_t, _program: program_handle_t, _indirectHandle: indirect_buffer_handle_t, _start, _num: c.uint16_t, _flags: c.uint8_t) ---
    
    /**
     * Discard previously set state for draw or compute call.
     *
     * @param[in] _flags Discard or preserve states. See `BGFX_DISCARD_*`.
     *
     */
    encoder_discard :: proc(_this: ^encoder_t, _flags: c.uint8_t) ---

    /**
     * Blit 2D texture region between two 2D textures.
     * @attention Destination texture must be created with `BGFX_TEXTURE_BLIT_DST` flag.
     * @attention Availability depends on: `BGFX_CAPS_TEXTURE_BLIT`.
     *
     * @param[in] _id View id.
     * @param[in] _dst Destination texture handle.
     * @param[in] _dstMip Destination texture mip level.
     * @param[in] _dstX Destination texture X position.
     * @param[in] _dstY Destination texture Y position.
     * @param[in] _dstZ If texture is 2D this argument should be 0. If destination texture is cube
     *  this argument represents destination texture cube face. For 3D texture this argument
     *  represents destination texture Z position.
     * @param[in] _src Source texture handle.
     * @param[in] _srcMip Source texture mip level.
     * @param[in] _srcX Source texture X position.
     * @param[in] _srcY Source texture Y position.
     * @param[in] _srcZ If texture is 2D this argument should be 0. If source texture is cube
     *  this argument represents source texture cube face. For 3D texture this argument
     *  represents source texture Z position.
     * @param[in] _width Width of region.
     * @param[in] _height Height of region.
     * @param[in] _depth If texture is 3D this argument represents depth of region, otherwise it's
     *  unused.
     *
     */
    encoder_blit :: proc(_this: ^encoder_t, _id: view_id_t, _dst: texture_handle_t, _dstMip: c.uint8_t, _dstX, _dstY, _dstZ: c.uint16_t, _src: texture_handle_t,
                         _fla_srcMipgs: c.uint8_t, _srcX, _srcY, _srcZ, _width, _height, _depth: c.uint16_t) ---
    /**
     * Request screen shot of window back buffer.
     * @remarks
     *   `bgfx::CallbackI::screenShot` must be implemented.
     * @attention Frame buffer handle must be created with OS' target native window handle.
     *
     * @param[in] _handle Frame buffer handle. If handle is `BGFX_INVALID_HANDLE` request will be
     *  made for main window back buffer.
     * @param[in] _filePath Will be passed to `bgfx::CallbackI::screenShot` callback.
     *
     */
    request_screen_shot :: proc(_handle: frame_buffer_handle_t, _filePath: cstring) ---

    /**
     * Render frame.
     * @attention `bgfx::renderFrame` is blocking call. It waits for
     *   `bgfx::frame` to be called from API thread to process frame.
     *   If timeout value is passed call will timeout and return even
     *   if `bgfx::frame` is not called.
     * @warning This call should be only used on platforms that don't
     *   allow creating separate rendering thread. If it is called before
     *   to bgfx::init, render thread won't be created by bgfx::init call.
     *
     * @param[in] _msecs Timeout in milliseconds.
     *
     * @returns Current renderer context state. See: `bgfx::RenderFrame`.
     *
     */
    render_frame :: proc(_msecs: c.int32_t) -> render_frame_t ---

    /**
     * Set platform data.
     * @warning Must be called before `bgfx::init`.
     *
     * @param[in] _data Platform data.
     *
     */
    set_platform_data :: proc(_data: ^platform_data_t) ---

    /**
     * Get internal data for interop.
     * @attention It's expected you understand some bgfx internals before you
     *   use this call.
     * @warning Must be called only on render thread.
     *
     */
    get_internal_data :: proc() -> ^internal_data_t ---

    /**
     * Override internal texture with externally created texture. Previously
     * created internal texture will released.
     * @attention It's expected you understand some bgfx internals before you
     *   use this call.
     * @warning Must be called only on render thread.
     *
     * @param[in] _handle Texture handle.
     * @param[in] _ptr Native API pointer to texture.
     *
     * @returns Native API pointer to texture. If result is 0, texture is not created
     *  yet from the main thread.
     *
     */
    override_internal_texture_ptr :: proc(_handle: texture_handle_t, _ptr: c.uintptr_t) -> c.uintptr_t ---

    /**
     * Override internal texture by creating new texture. Previously created
     * internal texture will released.
     * @attention It's expected you understand some bgfx internals before you
     *   use this call.
     * @returns Native API pointer to texture. If result is 0, texture is not created yet from the
     *   main thread.
     * @warning Must be called only on render thread.
     *
     * @param[in] _handle Texture handle.
     * @param[in] _width Width.
     * @param[in] _height Height.
     * @param[in] _numMips Number of mip-maps.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     * @param[in] _flags Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
     *  flags. Default texture sampling mode is linear, and wrap mode is repeat.
     *  - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *    mode.
     *  - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *    sampling.
     *
     * @returns Native API pointer to texture. If result is 0, texture is not created
     *  yet from the main thread.
     *
     */
    override_internal_texture :: proc(_handle: texture_handle_t, _width, _height: c.uint16_t, _numMips: c.uint8_t, _format: texture_format_t,
                                      _flags: c.uint64_t) -> c.uintptr_t ---

    /**
     * Sets a debug marker. This allows you to group graphics calls together for easy browsing in
     * graphics debugging tools.
     *
     * @param[in] _marker Marker string.
     *
     */
    set_marker :: proc(_marker: cstring) ---

    /**
     * Set render states for draw primitive.
     * @remarks
     *   1. To setup more complex states use:
     *      `BGFX_STATE_ALPHA_REF(_ref)`,
     *      `BGFX_STATE_POINT_SIZE(_size)`,
     *      `BGFX_STATE_BLEND_FUNC(_src, _dst)`,
     *      `BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA)`,
     *      `BGFX_STATE_BLEND_EQUATION(_equation)`,
     *      `BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA)`
     *   2. `BGFX_STATE_BLEND_EQUATION_ADD` is set when no other blend
     *      equation is specified.
     *
     * @param[in] _state State flags. Default state for primitive type is
     *    triangles. See: `BGFX_STATE_DEFAULT`.
     *    - `BGFX_STATE_DEPTH_TEST_*` - Depth test function.
     *    - `BGFX_STATE_BLEND_*` - See remark 1 about BGFX_STATE_BLEND_FUNC.
     *    - `BGFX_STATE_BLEND_EQUATION_*` - See remark 2.
     *    - `BGFX_STATE_CULL_*` - Backface culling mode.
     *    - `BGFX_STATE_WRITE_*` - Enable R, G, B, A or Z write.
     *    - `BGFX_STATE_MSAA` - Enable hardware multisample antialiasing.
     *    - `BGFX_STATE_PT_[TRISTRIP/LINES/POINTS]` - Primitive type.
     * @param[in] _rgba Sets blend factor used by `BGFX_STATE_BLEND_FACTOR` and
     *    `BGFX_STATE_BLEND_INV_FACTOR` blend modes.
     *
     */
    set_state :: proc(_state: c.uint64_t, _rgba: c.uint32_t) ---

    /**
     * Set condition for rendering.
     *
     * @param[in] _handle Occlusion query handle.
     * @param[in] _visible Render if occlusion query is visible.
     *
     */
    set_condition :: proc(_handle: occlusion_query_handle_t, _visible: c.bool) ---

    /**
     * Set stencil test state.
     *
     * @param[in] _fstencil Front stencil state.
     * @param[in] _bstencil Back stencil state. If back is set to `BGFX_STENCIL_NONE`
     *  _fstencil is applied to both front and back facing primitives.
     *
     */
    set_stencil :: proc(_fstencil, _bstencil: c.uint32_t) ---

    /**
     * Set scissor for draw primitive.
     * @remark
     *   To scissor for all primitives in view see `bgfx::setViewScissor`.
     *
     * @param[in] _x Position x from the left corner of the window.
     * @param[in] _y Position y from the top corner of the window.
     * @param[in] _width Width of view scissor region.
     * @param[in] _height Height of view scissor region.
     *
     * @returns Scissor cache index.
     *
     */
    set_scissor :: proc(_x, _y, _width, _height: c.uint16_t) -> c.uint16_t ---

    /**
     * Set scissor from cache for draw primitive.
     * @remark
     *   To scissor for all primitives in view see `bgfx::setViewScissor`.
     *
     * @param[in] _cache Index in scissor cache.
     *
     */
    set_scissor_cached :: proc(_cache: c.uint16_t) ---

    /**
     * Set model matrix for draw primitive. If it is not called,
     * the model will be rendered with an identity model matrix.
     *
     * @param[in] _mtx Pointer to first matrix in array.
     * @param[in] _num Number of matrices in array.
     *
     * @returns Index into matrix cache in case the same model matrix has
     *  to be used for other draw primitive call.
     *
     */
    set_transform :: proc(_mtx: rawptr, _num: c.uint16_t) -> c.uint32_t ---

    /**
     *  Set model matrix from matrix cache for draw primitive.
     *
     * @param[in] _cache Index in matrix cache.
     * @param[in] _num Number of matrices from cache.
     *
     */
    set_transform_cached :: proc(_cache: c.uint32_t, _num: c.uint16_t) ---

    /**
     * Reserve matrices in internal matrix cache.
     * @attention Pointer returned can be modifed until `bgfx::frame` is called.
     *
     * @param[out] _transform Pointer to `Transform` structure.
     * @param[in] _num Number of matrices.
     *
     * @returns Index in matrix cache.
     *
     */
    alloc_transform :: proc(_transform: ^transform_t, _num: c.uint16_t) -> c.uint32_t ---

    /**
     * Set shader uniform parameter for draw primitive.
     *
     * @param[in] _handle Uniform.
     * @param[in] _value Pointer to uniform data.
     * @param[in] _num Number of elements. Passing `UINT16_MAX` will
     *  use the _num passed on uniform creation.
     *
     */
    set_uniform :: proc(_handle: uniform_handle_t, _value: rawptr, _num: c.uint16_t) ---

    /**
     * Set index buffer for draw primitive.
     *
     * @param[in] _handle Index buffer.
     * @param[in] _firstIndex First index to render.
     * @param[in] _numIndices Number of indices to render.
     *
     */
    set_index_buffer :: proc(_handle: index_buffer_handle_t, _firstIndex, _numIndices: c.uint32_t) ---

    /**
     * Set index buffer for draw primitive.
     *
     * @param[in] _handle Dynamic index buffer.
     * @param[in] _firstIndex First index to render.
     * @param[in] _numIndices Number of indices to render.
     *
     */
    set_dynamic_index_buffer :: proc(_handle: dynamic_index_buffer_handle_t, _firstIndex, _numIndices: c.uint32_t) ---

    /**
     * Set index buffer for draw primitive.
     *
     * @param[in] _tib Transient index buffer.
     * @param[in] _firstIndex First index to render.
     * @param[in] _numIndices Number of indices to render.
     *
     */
    set_transient_index_buffer :: proc(_tib: ^transient_index_buffer_t, _firstIndex, _numIndices: c.uint32_t) ---

    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _handle Vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     *
     */
    set_vertex_buffer :: proc(_stream: c.uint8_t, _handle: vertex_buffer_handle_t, _startVertex, _numVertices: c.uint32_t) ---

    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _handle Vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     * @param[in] _layoutHandle Vertex layout for aliasing vertex buffer. If invalid
     *  handle is used, vertex layout used for creation
     *  of vertex buffer will be used.
     *
     */
    set_vertex_buffer_with_layout :: proc(_stream: c.uint8_t, _handle: vertex_buffer_handle_t, _startVertex, _numVertices: c.uint32_t,
                                          _layoutHandle: vertex_layout_handle_t) ---

    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _handle Dynamic vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     *
     */
    set_dynamic_vertex_buffer :: proc(_stream: c.uint8_t, _handle: dynamic_vertex_buffer_handle_t, _startVertex, _numVertices: c.uint32_t) ---

    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _handle Dynamic vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     * @param[in] _layoutHandle Vertex layout for aliasing vertex buffer. If invalid
     *  handle is used, vertex layout used for creation
     *  of vertex buffer will be used.
     *
     */
     set_dynamic_vertex_buffer_with_layout :: proc(_stream: c.uint8_t, _handle: dynamic_vertex_buffer_handle_t, _startVertex, _numVertices: c.uint32_t, 
                                                   _layoutHandle: vertex_layout_handle_t) ---
    
    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _tvb Transient vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     *
     */
    set_transient_vertex_buffer :: proc(_stream: c.uint8_t, _tvb: ^transient_vertex_buffer_t, _startVertex, _numVertices: c.uint32_t) ---

    /**
     * Set vertex buffer for draw primitive.
     *
     * @param[in] _stream Vertex stream.
     * @param[in] _tvb Transient vertex buffer.
     * @param[in] _startVertex First vertex to render.
     * @param[in] _numVertices Number of vertices to render.
     * @param[in] _layoutHandle Vertex layout for aliasing vertex buffer. If invalid
     *  handle is used, vertex layout used for creation
     *  of vertex buffer will be used.
     *
     */
    set_transient_vertex_buffer_with_layout :: proc(_stream: c.uint8_t, _tvb: ^transient_vertex_buffer_t, _startVertex, _numVertices: c.uint32_t,
                                                    _layoutHandle: vertex_layout_handle_t) ---

    /**
     * Set number of vertices for auto generated vertices use in conjuction
     * with gl_VertexID.
     * @attention Availability depends on: `BGFX_CAPS_VERTEX_ID`.
     *
     * @param[in] _numVertices Number of vertices.
     *
     */
    set_vertex_count :: proc(_numVertices: c.uint32_t) ---

    /**
     * Set instance data buffer for draw primitive.
     *
     * @param[in] _idb Transient instance data buffer.
     * @param[in] _start First instance data.
     * @param[in] _num Number of data instances.
     *
     */
    set_instance_data_buffer :: proc(_idb: ^instance_data_buffer_t, _start, _num: c.uint32_t) ---

    /**
     * Set instance data buffer for draw primitive.
     *
     * @param[in] _handle Vertex buffer.
     * @param[in] _startVertex First instance data.
     * @param[in] _num Number of data instances.
     *  Set instance data buffer for draw primitive.
     *
     */
    set_instance_data_from_vertex_buffe :: proc(_handle: vertex_buffer_handle_t, _startVertex, _num: c.uint32_t) ---

    /**
     * Set instance data buffer for draw primitive.
     *
     * @param[in] _handle Dynamic vertex buffer.
     * @param[in] _startVertex First instance data.
     * @param[in] _num Number of data instances.
     *
     */
    set_instance_data_from_dynamic_vertex_buffer :: proc(_handle: dynamic_vertex_buffer_handle_t, _startVertex, _num: c.uint32_t) ---

    /**
     * Set number of instances for auto generated instances use in conjuction
     * with gl_InstanceID.
     * @attention Availability depends on: `BGFX_CAPS_VERTEX_ID`.
     *
     * @param[in] _numInstances
     *
     */
    set_instance_count :: proc(_numInstances: c.uint32_t) ---

    /**
     * Set texture stage for draw primitive.
     *
     * @param[in] _stage Texture unit.
     * @param[in] _sampler Program sampler.
     * @param[in] _handle Texture handle.
     * @param[in] _flags Texture sampling mode. Default value UINT32_MAX uses
     *    texture sampling settings from the texture.
     *    - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
     *      mode.
     *    - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
     *      sampling.
     *
     */
    set_texture :: proc(_stage: c.uint8_t, _sampler: uniform_handle_t, _handle: texture_handle_t, _flags: c.uint32_t) ---

    /**
     * Submit an empty primitive for rendering. Uniforms and draw state
     * will be applied but no geometry will be submitted.
     * @remark
     *   These empty draw calls will sort before ordinary draw calls.
     *
     * @param[in] _id View id.
     *
     */
    touch :: proc(_id: view_id_t) ---

    /**
     * Submit primitive for rendering.
     *
     * @param[in] _id View id.
     * @param[in] _program Program.
     * @param[in] _depth Depth for sorting.
     * @param[in] _flags Which states to discard for next draw. See `BGFX_DISCARD_*`.
     *
     */
    submit :: proc(_id: view_id_t, _program: program_handle_t, _depth: c.uint32_t, _flags: c.uint8_t) ---

    /**
     * Submit primitive with occlusion query for rendering.
     *
     * @param[in] _id View id.
     * @param[in] _program Program.
     * @param[in] _occlusionQuery Occlusion query.
     * @param[in] _depth Depth for sorting.
     * @param[in] _flags Which states to discard for next draw. See `BGFX_DISCARD_*`.
     *
     */
    submit_occlusion_query :: proc(_id: view_id_t, _program: program_handle_t, _occlusionQuery: occlusion_query_handle_t, _depth: c.uint32_t, _flags: c.uint8_t) ---

    /**
     * Submit primitive for rendering with index and instance data info from
     * indirect buffer.
     *
     * @param[in] _id View id.
     * @param[in] _program Program.
     * @param[in] _indirectHandle Indirect buffer.
     * @param[in] _start First element in indirect buffer.
     * @param[in] _num Number of dispatches.
     * @param[in] _depth Depth for sorting.
     * @param[in] _flags Which states to discard for next draw. See `BGFX_DISCARD_*`.
     *
     */
    submit_indirect :: proc(_id: view_id_t, _program: program_handle_t, _indirectHandle: indirect_buffer_handle_t, _start, _num: c.uint16_t, _depth: c.uint32_t,
                            _flags: c.uint8_t) ---

    /**
     * Set compute index buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Index buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    set_compute_index_buffer :: proc(_stage: c.uint8_t, _handle: index_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute vertex buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Vertex buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    set_compute_vertex_buffer :: proc(_stage: c.uint8_t, _handle: vertex_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute dynamic index buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Dynamic index buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    set_compute_dynamic_index_buffer :: proc(_stage: c.uint8_t, _handle: dynamic_index_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute dynamic vertex buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Dynamic vertex buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    set_compute_dynamic_vertex_buffer :: proc(_stage: c.uint8_t, _handle: dynamic_vertex_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute indirect buffer.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Indirect buffer handle.
     * @param[in] _access Buffer access. See `Access::Enum`.
     *
     */
    set_compute_indirect_buffer :: proc(_stage: c.uint8_t, _handle: indirect_buffer_handle_t, _access: access_t) ---

    /**
     * Set compute image from texture.
     *
     * @param[in] _stage Compute stage.
     * @param[in] _handle Texture handle.
     * @param[in] _mip Mip level.
     * @param[in] _access Image access. See `Access::Enum`.
     * @param[in] _format Texture format. See: `TextureFormat::Enum`.
     *
     */
    set_image :: proc(_stage: c.uint8_t, _handle: texture_handle_t, _mip: c.uint8_t, _access: access_t, _format: texture_format_t) ---

    /**
     * Dispatch compute.
     *
     * @param[in] _id View id.
     * @param[in] _program Compute program.
     * @param[in] _numX Number of groups X.
     * @param[in] _numY Number of groups Y.
     * @param[in] _numZ Number of groups Z.
     * @param[in] _flags Discard or preserve states. See `BGFX_DISCARD_*`.
     *
     */
    dispatch :: proc(_id: view_id_t, _program: program_handle_t, _numX, _numY, _numZ: c.uint32_t, _flags: c.uint8_t) ---

    /**
     * Dispatch compute indirect.
     *
     * @param[in] _id View id.
     * @param[in] _program Compute program.
     * @param[in] _indirectHandle Indirect buffer.
     * @param[in] _start First element in indirect buffer.
     * @param[in] _num Number of dispatches.
     * @param[in] _flags Discard or preserve states. See `BGFX_DISCARD_*`.
     *
     */
    dispatch_indirect :: proc(_id: view_id_t, _program: program_handle_t, _indirectHandle: indirect_buffer_handle_t, _start, _num: c.uint16_t, _flags: c.uint8_t) ---

    /**
     * Discard previously set state for draw or compute call.
     *
     * @param[in] _flags Draw/compute states to discard.
     *
     */
    discard :: proc(_flags: c.uint8_t) ---

    /**
     * Blit 2D texture region between two 2D textures.
     * @attention Destination texture must be created with `BGFX_TEXTURE_BLIT_DST` flag.
     * @attention Availability depends on: `BGFX_CAPS_TEXTURE_BLIT`.
     *
     * @param[in] _id View id.
     * @param[in] _dst Destination texture handle.
     * @param[in] _dstMip Destination texture mip level.
     * @param[in] _dstX Destination texture X position.
     * @param[in] _dstY Destination texture Y position.
     * @param[in] _dstZ If texture is 2D this argument should be 0. If destination texture is cube
     *  this argument represents destination texture cube face. For 3D texture this argument
     *  represents destination texture Z position.
     * @param[in] _src Source texture handle.
     * @param[in] _srcMip Source texture mip level.
     * @param[in] _srcX Source texture X position.
     * @param[in] _srcY Source texture Y position.
     * @param[in] _srcZ If texture is 2D this argument should be 0. If source texture is cube
     *  this argument represents source texture cube face. For 3D texture this argument
     *  represents source texture Z position.
     * @param[in] _width Width of region.
     * @param[in] _height Height of region.
     * @param[in] _depth If texture is 3D this argument represents depth of region, otherwise it's
     *  unused.
     *
     */
    blit :: proc(_id: view_id_t, _dst: texture_handle_t, _dstMip: c.uint8_t, _dstX, _dstY, _dstZ: c.uint16_t, _src: texture_handle_t,
                 _srcMip: c.uint8_t, _srcX, _srcY, _srcZ, _width, _height, _depth: c.uint16_t) ---
}

/*
interface_vtbl_t :: struct {
    attachment_init                                      : proc "c" (_this: ^attachment_t, _handle: texture_handle_t, _access: access_t, _layer, _numLayers, _mip: c.uint16_t, _resolve: c.uint8_t),
    vertex_layout_begin                                  : proc "c" (_this: ^vertex_layout_t, _rendererType: renderer_type_t) -> ^vertex_layout_t,
    vertex_layout_add                                    : proc "c" (_this: ^vertex_layout_t, _attrib: attrib_t, _num: c.uint8_t, _type: attrib_type_t, _normalized, _asInt: c.bool) -> ^vertex_layout_t,
    vertex_layout_decode                                 : proc "c" (_this: ^vertex_layout_t, _attrib: attrib_t, _num: ^c.uint8_t, _type: ^attrib_type_t, _normalized, _asInt: ^c.bool),
    vertex_layout_has                                    : proc "c" (_this: ^vertex_layout_t, _num: c.uint8_t) -> c.bool,
    vertex_layout_skip                                   : proc "c" (_this: ^vertex_layout_t, _num: c.uint8_t) -> ^vertex_layout_t,
    vertex_layout_end                                    : proc "c" (_this: ^vertex_layout_t),
    vertex_pack                                          : proc "c" (_input: [4]c.float, _inputNormalized: c.bool, _attr: attrib_t, _layout: ^vertex_layout_t, _data: rawptr, _index: c.uint32_t),
    vertex_unpack                                        : proc "c" (_output: [4]c.float, _attr: attrib_t, _layout: ^vertex_layout_t, _data: rawptr, _index: c.uint32_t),
    vertex_convert                                       : proc "c" (_dstLayout: ^vertex_layout_t, _dstData: rawptr, _srcLayout: ^vertex_layout_t, _srcData: rawptr, _num: c.uint32_t),
    weld_vertices                                        : proc "c" (_output: rawptr, _layout: ^vertex_layout_t, _data: rawptr, _num: c.uint32_t, _index32: c.bool, _epsilon: c.float) -> c.uint32_t,
    topology_convert                                     : proc "c" (_conversion: topology_convert_t, _dst: rawptr, _dstSize: c.uint32_t, _indices: rawptr, _numIndices: c.uint32_t, _index32: c.bool) -> c.uint32_t,
    topology_sort_tri_list                               : proc "c" (_sort: topology_sort_t, _dst: rawptr, _dstSize: c.uint32_t, _dir, _pos: [3]c.float, _vertices: rawptr, _stride: c.uint32_t, _indices: rawptr,
                                                                     _numIndices: c.uint32_t, _index32: c.bool),
    get_supported_renderers                              : proc "c" (_max: c.uint8_t, _enum: ^renderer_type_t),
    get_renderer_name                                    : proc "c" (_type: renderer_type_t) -> cstring,
    init_ctor                                            : proc "c" (_init: ^init_t),
    init                                                 : proc "c" (_init: ^init_t),
    shutdown                                             : proc "c" (),
    reset                                                : proc "c" (_width, _height, _flags: c.uint32_t, _format: texture_format_t),
    frame                                                : proc "c" (_capture: c.bool) -> c.uint32_t,
    get_renderer_type                                    : proc "c" () -> renderer_type_t,
    get_caps                                             : proc "c" () -> ^caps_t,
    get_stats                                            : proc "c" () -> ^stats_t,
    alloc                                                : proc "c" (_size: c.uint32_t) -> ^memory_t,
    copy                                                 : proc "c" (_data: rawptr, _size: c.uint32_t) -> ^memory_t,
    make_ref                                             : proc "c" (_data: rawptr, _size: c.uint32_t) -> ^memory_t,
    make_ref_release                                     : proc "c" (_data: rawptr, _size: c.uint32_t, _releaseFn: release_fn_t, _userData: rawptr) -> ^memory_t,
    set_debug                                            : proc "c" (),
    dbg_text_clear                                       : proc "c" (),
    dbg_text_printf                                      : proc "c" (),
    dbg_text_vprintf                                     : proc "c" (),
    dbg_text_image                                       : proc "c" (),
    create_index_buffer                                  : proc "c" (),
    set_index_buffer_name                                : proc "c" (),
    destroy_index_buffer                                 : proc "c" (),
    create_vertex_layout                                 : proc "c" (),
    destroy_vertex_layout                                : proc "c" (),
    create_vertex_buffer                                 : proc "c" (),
    set_vertex_buffer_name                               : proc "c" (),
    destroy_vertex_buffer                                : proc "c" (),
    create_dynamic_index_buffer                          : proc "c" (),
    create_dynamic_index_buffer_mem                      : proc "c" (),
    update_dynamic_index_buffer                          : proc "c" (),
    destroy_dynamic_index_buffer                         : proc "c" (),
    create_dynamic_vertex_buffer                         : proc "c" (),
    create_dynamic_vertex_buffer_mem                     : proc "c" (),
    update_dynamic_vertex_buffer                         : proc "c" (),
    destroy_dynamic_vertex_buffer                        : proc "c" (),
    get_avail_transient_index_buffer                     : proc "c" (),
    get_avail_transient_vertex_buffer                    : proc "c" (),
    get_avail_instance_data_buffer                       : proc "c" (),
    alloc_transient_index_buffer                         : proc "c" (),
    alloc_transient_vertex_buffer                        : proc "c" (),
    alloc_transient_buffers                              : proc "c" (),
    alloc_instance_data_buffer                           : proc "c" (),
    create_indirect_buffer                               : proc "c" (),
    destroy_indirect_buffer                              : proc "c" (),
    create_shader                                        : proc "c" (),
    get_shader_uniforms                                  : proc "c" (),
    set_shader_name                                      : proc "c" (),
    destroy_shader                                       : proc "c" (),
    create_program                                       : proc "c" (),
    create_compute_program                               : proc "c" (),
    destroy_program                                      : proc "c" (),
    is_texture_valid                                     : proc "c" (),
    is_frame_buffer_valid                                : proc "c" (),
    calc_texture_size                                    : proc "c" (),
    create_texture                                       : proc "c" (),
    create_texture_2d                                    : proc "c" (),
    create_texture_2d_scaled                             : proc "c" (),
    create_texture_3d                                    : proc "c" (),
    create_texture_cube                                  : proc "c" (),
    update_texture_2d                                    : proc "c" (),
    update_texture_3d                                    : proc "c" (),
    update_texture_cube                                  : proc "c" (),
    read_texture                                         : proc "c" (),
    set_texture_name                                     : proc "c" (),
    get_direct_access_ptr                                : proc "c" (),
    destroy_texture                                      : proc "c" (),
    create_frame_buffer                                  : proc "c" (),
    create_frame_buffer_scaled                           : proc "c" (),
    create_frame_buffer_from_handles                     : proc "c" (),
    create_frame_buffer_from_attachment                  : proc "c" (),
    create_frame_buffer_from_nwh                         : proc "c" (),
    set_frame_buffer_name                                : proc "c" (),
    get_texture                                          : proc "c" (),
    destroy_frame_buffer                                 : proc "c" (),
    create_uniform                                       : proc "c" (),
    get_uniform_info                                     : proc "c" (),
    destroy_uniform                                      : proc "c" (),
    create_occlusion_query                               : proc "c" (),
    get_result                                           : proc "c" (),
    destroy_occlusion_query                              : proc "c" (),
    set_palette_color                                    : proc "c" (),
    set_palette_color_rgba8                              : proc "c" (),
    set_view_name                                        : proc "c" (),
    set_view_rect                                        : proc "c" (),
    set_view_rect_ratio                                  : proc "c" (),
    set_view_scissor                                     : proc "c" (),
    set_view_clear                                       : proc "c" (),
    set_view_clear_mrt                                   : proc "c" (),
    set_view_mode                                        : proc "c" (),
    set_view_frame_buffer                                : proc "c" (),
    set_view_transform                                   : proc "c" (),
    set_view_order                                       : proc "c" (),
    reset_view                                           : proc "c" (),
    encoder_begin                                        : proc "c" (),
    encoder_end                                          : proc "c" (),
    encoder_set_marker                                   : proc "c" (),
    encoder_set_state                                    : proc "c" (),
    encoder_set_condition                                : proc "c" (),
    encoder_set_stencil                                  : proc "c" (),
    encoder_set_scissor                                  : proc "c" (),
    encoder_set_scissor_cached                           : proc "c" (),
    encoder_set_transform                                : proc "c" (),
    encoder_set_transform_cached                         : proc "c" (),
    encoder_alloc_transform                              : proc "c" (),
    encoder_set_uniform                                  : proc "c" (),
    encoder_set_index_buffer                             : proc "c" (),
    encoder_set_dynamic_index_buffer                     : proc "c" (),
    encoder_set_transient_index_buffer                   : proc "c" (),
    encoder_set_vertex_buffer                            : proc "c" (),
    encoder_set_vertex_buffer_with_layout                : proc "c" (),
    encoder_set_dynamic_vertex_buffer                    : proc "c" (),
    encoder_set_dynamic_vertex_buffer_with_layout        : proc "c" (),
    encoder_set_transient_vertex_buffer                  : proc "c" (),
    encoder_set_transient_vertex_buffer_with_layout      : proc "c" (),
    encoder_set_vertex_count                             : proc "c" (),
    encoder_set_instance_data_buffer                     : proc "c" (),
    encoder_set_instance_data_from_vertex_buffer         : proc "c" (),
    encoder_set_instance_data_from_dynamic_vertex_buffer : proc "c" (),
    encoder_set_instance_count                           : proc "c" (),
    encoder_set_texture                                  : proc "c" (),
    encoder_touch                                        : proc "c" (),
    encoder_submit                                       : proc "c" (),
    encoder_submit_occlusion_query                       : proc "c" (),
    encoder_submit_indirect                              : proc "c" (),
    encoder_set_compute_index_buffer                     : proc "c" (),
    encoder_set_compute_vertex_buffer                    : proc "c" (),
    encoder_set_compute_dynamic_index_buffer             : proc "c" (),
    encoder_set_compute_dynamic_vertex_buffer            : proc "c" (),
    encoder_set_compute_indirect_buffer                  : proc "c" (),
    encoder_set_image                                    : proc "c" (),
    encoder_dispatch                                     : proc "c" (),
    encoder_dispatch_indirect                            : proc "c" (),
    encoder_discard                                      : proc "c" (),
    encoder_blit                                         : proc "c" (),
    request_screen_shot                                  : proc "c" (),
    render_frame                                         : proc "c" (),
    set_platform_data                                    : proc "c" (),
    get_internal_data                                    : proc "c" (),
    override_internal_texture_ptr                        : proc "c" (),
    override_internal_texture                            : proc "c" (),
    set_marker                                           : proc "c" (),
    set_state                                            : proc "c" (),
    set_condition                                        : proc "c" (),
    set_stencil                                          : proc "c" (),
    set_scissor                                          : proc "c" (),
    set_scissor_cached                                   : proc "c" (),
    set_transform                                        : proc "c" (),
    set_transform_cached                                 : proc "c" (),
    alloc_transform                                      : proc "c" (),
    set_uniform                                          : proc "c" (),
    set_index_buffer                                     : proc "c" (),
    set_dynamic_index_buffer                             : proc "c" (),
    set_transient_index_buffer                           : proc "c" (),
    set_vertex_buffer                                    : proc "c" (),
    set_vertex_buffer_with_layout                        : proc "c" (),
    set_dynamic_vertex_buffer                            : proc "c" (),
    set_dynamic_vertex_buffer_with_layout                : proc "c" (),
    set_transient_vertex_buffer                          : proc "c" (),
    set_transient_vertex_buffer_with_layout              : proc "c" (),
    set_vertex_count                                     : proc "c" (),
    set_instance_data_buffer                             : proc "c" (),
    set_instance_data_from_vertex_buffer                 : proc "c" (),
    set_instance_data_from_dynamic_vertex_buffer         : proc "c" (),
    set_instance_count                                   : proc "c" (),
    set_texture                                          : proc "c" (),
    touch                                                : proc "c" (),
    submit                                               : proc "c" (),
    submit_occlusion_query                               : proc "c" (),
    submit_indirect                                      : proc "c" (),
    set_compute_index_buffer                             : proc "c" (),
    set_compute_vertex_buffer                            : proc "c" (),
    set_compute_dynamic_index_buffer                     : proc "c" (),
    set_compute_dynamic_vertex_buffer                    : proc "c" (),
    set_compute_indirect_buffer                          : proc "c" (),
    set_image                                            : proc "c" (),
    dispatch                                             : proc "c" (),
    dispatch_indirect                                    : proc "c" (),
    discard                                              : proc "c" (),
    blit                                                 : proc "c" (),
}*/

// get_interface :: #type proc "c" (_version: c.uint32_t) -> ^interface_vtbl_t