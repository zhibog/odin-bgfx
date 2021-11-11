package bgfx

/*
    Copyright 2021 zhibog
    License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause

    List of contributors:
        zhibog: Initial implementation.

    BGFX defines, taken from <https://github.com/bkaradzic/bgfx/blob/master/include/bgfx/defines.h>

    The "bgfx_" prefix has been stripped from the identifiers to remove redundancy.
*/

API_VERSION : u32 : 115

/**
 * Color RGB/alpha/depth write. When it's not specified write will be disabled.
 *
 */
STATE_WRITE_R : u64 : 0x0000000000000001 //!< Enable R write.
STATE_WRITE_G : u64 : 0x0000000000000002 //!< Enable G write.
STATE_WRITE_B : u64 : 0x0000000000000004 //!< Enable B write.
STATE_WRITE_A : u64 : 0x0000000000000008 //!< Enable alpha write.
STATE_WRITE_Z : u64 : 0x0000004000000000 //!< Enable depth write.
/// Enable RGB write.
STATE_WRITE_RGB :: 0 | STATE_WRITE_R | STATE_WRITE_G | STATE_WRITE_B

/// Write all channels mask.
STATE_WRITE_MASK :: 0 | STATE_WRITE_RGB | STATE_WRITE_A | STATE_WRITE_Z

/**
 * Depth test state. When `BGFX_STATE_DEPTH_` is not specified depth test will be disabled.
 *
 */
STATE_DEPTH_TEST_LESS     : u64 : 0x0000000000000010 //!< Enable depth test, less.
STATE_DEPTH_TEST_LEQUAL   : u64 : 0x0000000000000020 //!< Enable depth test, less or equal.
STATE_DEPTH_TEST_EQUAL    : u64 : 0x0000000000000030 //!< Enable depth test, equal.
STATE_DEPTH_TEST_GEQUAL   : u64 : 0x0000000000000040 //!< Enable depth test, greater or equal.
STATE_DEPTH_TEST_GREATER  : u64 : 0x0000000000000050 //!< Enable depth test, greater.
STATE_DEPTH_TEST_NOTEQUAL : u64 : 0x0000000000000060 //!< Enable depth test, not equal.
STATE_DEPTH_TEST_NEVER    : u64 : 0x0000000000000070 //!< Enable depth test, never.
STATE_DEPTH_TEST_ALWAYS   : u64 : 0x0000000000000080 //!< Enable depth test, always.
STATE_DEPTH_TEST_SHIFT    :     : 4                  //!< Depth test state bit shift
STATE_DEPTH_TEST_MASK     : u64 : 0x00000000000000f0 //!< Depth test state bit mask

/**
 * Use BGFX_STATE_BLEND_FUNC(_src, _dst) or BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA)
 * helper macros.
 *
 */
STATE_BLEND_ZERO          : u64 : 0x0000000000001000 //!< 0, 0, 0, 0
STATE_BLEND_ONE           : u64 : 0x0000000000002000 //!< 1, 1, 1, 1
STATE_BLEND_SRC_COLOR     : u64 : 0x0000000000003000 //!< Rs, Gs, Bs, As
STATE_BLEND_INV_SRC_COLOR : u64 : 0x0000000000004000 //!< 1-Rs, 1-Gs, 1-Bs, 1-As
STATE_BLEND_SRC_ALPHA     : u64 : 0x0000000000005000 //!< As, As, As, As
STATE_BLEND_INV_SRC_ALPHA : u64 : 0x0000000000006000 //!< 1-As, 1-As, 1-As, 1-As
STATE_BLEND_DST_ALPHA     : u64 : 0x0000000000007000 //!< Ad, Ad, Ad, Ad
STATE_BLEND_INV_DST_ALPHA : u64 : 0x0000000000008000 //!< 1-Ad, 1-Ad, 1-Ad ,1-Ad
STATE_BLEND_DST_COLOR     : u64 : 0x0000000000009000 //!< Rd, Gd, Bd, Ad
STATE_BLEND_INV_DST_COLOR : u64 : 0x000000000000a000 //!< 1-Rd, 1-Gd, 1-Bd, 1-Ad
STATE_BLEND_SRC_ALPHA_SAT : u64 : 0x000000000000b000 //!< f, f, f, 1; f = min(As, 1-Ad)
STATE_BLEND_FACTOR        : u64 : 0x000000000000c000 //!< Blend factor
STATE_BLEND_INV_FACTOR    : u64 : 0x000000000000d000 //!< 1-Blend factor
STATE_BLEND_SHIFT         :     : 12                 //!< Blend state bit shift
STATE_BLEND_MASK          : u64 : 0x000000000ffff000 //!< Blend state bit mask

/**
 * Use BGFX_STATE_BLEND_EQUATION(_equation) or BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA)
 * helper macros.
 *
 */
STATE_BLEND_EQUATION_ADD    : u64 : 0x0000000000000000 //!< Blend add: src + dst.
STATE_BLEND_EQUATION_SUB    : u64 : 0x0000000010000000 //!< Blend subtract: src - dst.
STATE_BLEND_EQUATION_REVSUB : u64 : 0x0000000020000000 //!< Blend reverse subtract: dst - src.
STATE_BLEND_EQUATION_MIN    : u64 : 0x0000000030000000 //!< Blend min: min(src, dst).
STATE_BLEND_EQUATION_MAX    : u64 : 0x0000000040000000 //!< Blend max: max(src, dst).
STATE_BLEND_EQUATION_SHIFT  :     : 28                 //!< Blend equation bit shift
STATE_BLEND_EQUATION_MASK   : u64 : 0x00000003f0000000 //!< Blend equation bit mask

/**
 * Cull state. When `BGFX_STATE_CULL_*` is not specified culling will be disabled.
 *
 */
STATE_CULL_CW    : u64 : 0x0000001000000000 //!< Cull clockwise triangles.
STATE_CULL_CCW   : u64 : 0x0000002000000000 //!< Cull counter-clockwise triangles.
STATE_CULL_SHIFT :     : 36                 //!< Culling mode bit shift
STATE_CULL_MASK  : u64 : 0x0000003000000000 //!< Culling mode bit mask

/**
 * Alpha reference value.
 *
 */
STATE_ALPHA_REF_SHIFT : u64 : 40                 //!< Alpha reference bit shift
STATE_ALPHA_REF_MASK  : u64 : 0x0000ff0000000000 //!< Alpha reference bit mask
STATE_ALPHA_REF :: #force_inline proc "contextless" (v: u64) -> u64 { return (v << STATE_ALPHA_REF_SHIFT) & STATE_ALPHA_REF_MASK }

STATE_PT_TRISTRIP  : u64 : 0x0001000000000000 //!< Tristrip.
STATE_PT_LINES     : u64 : 0x0002000000000000 //!< Lines.
STATE_PT_LINESTRIP : u64 : 0x0003000000000000 //!< Line strip.
STATE_PT_POINTS    : u64 : 0x0004000000000000 //!< Points.
STATE_PT_SHIFT     :     : 48                 //!< Primitive type bit shift
STATE_PT_MASK      : u64 : 0x0007000000000000 //!< Primitive type bit mask

/**
 * Point size value.
 *
 */
STATE_POINT_SIZE_SHIFT : u64 : 52                 //!< Point size bit shift
STATE_POINT_SIZE_MASK  : u64 : 0x00f0000000000000 //!< Point size bit mask
STATE_POINT_SIZE :: #force_inline proc "contextless" (v: u64) -> u64 { return (v << STATE_POINT_SIZE_SHIFT) & STATE_POINT_SIZE_MASK }

/**
 * Enable MSAA write when writing into MSAA frame buffer.
 * This flag is ignored when not writing into MSAA frame buffer.
 *
 */
STATE_MSAA                    : u64 : 0x0100000000000000 //!< Enable MSAA rasterization.
STATE_LINEAA                  : u64 : 0x0200000000000000 //!< Enable line AA rasterization.
STATE_CONSERVATIVE_RASTER     : u64 : 0x0400000000000000 //!< Enable conservative rasterization.
STATE_NONE                    : u64 : 0x0000000000000000 //!< No state.
STATE_FRONT_CCW               : u64 : 0x0000008000000000 //!< Front counter-clockwise (default is clockwise).
STATE_BLEND_INDEPENDENT       : u64 : 0x0000000400000000 //!< Enable blend independent.
STATE_BLEND_ALPHA_TO_COVERAGE : u64 : 0x0000000800000000 //!< Enable alpha to coverage.
/// Default state is write to RGB, alpha, and depth with depth test less enabled, with clockwise
/// culling and MSAA (when writing into MSAA frame buffer, otherwise this flag is ignored).
STATE_DEFAULT :: 0 | STATE_WRITE_RGB | STATE_WRITE_A | STATE_WRITE_Z | STATE_DEPTH_TEST_LESS | STATE_CULL_CW | STATE_MSAA

STATE_MASK : u64 : 0xffffffffffffffff //!< State bit mask

/**
 * Do not use!
 *
 */
STATE_RESERVED_SHIFT :: 61

STATE_RESERVED_MASK : u64 : 0xe000000000000000

/**
 * Set stencil ref value.
 *
 */
STENCIL_FUNC_REF_SHIFT :: 0

STENCIL_FUNC_REF_MASK : u32 : 0x000000ff
STENCIL_FUNC_REF :: #force_inline proc "contextless" (v: u32) -> u32 { return (v << STENCIL_FUNC_REF_SHIFT) & STENCIL_FUNC_REF_MASK }

/**
 * Set stencil rmask value.
 *
 */
STENCIL_FUNC_RMASK_SHIFT :: 8

STENCIL_FUNC_RMASK_MASK : u32 : 0x0000ff00
STENCIL_FUNC_RMASK :: #force_inline proc "contextless" (v: u32) -> u32 { return (v << STENCIL_FUNC_RMASK_SHIFT) & STENCIL_FUNC_RMASK_MASK }

STENCIL_NONE              : u32 : 0x00000000
STENCIL_MASK              : u32 : 0xffffffff
STENCIL_DEFAULT           : u32 : 0x00000000

STENCIL_TEST_LESS         : u32 : 0x00010000 //!< Enable stencil test, less.
STENCIL_TEST_LEQUAL       : u32 : 0x00020000 //!< Enable stencil test, less or equal.
STENCIL_TEST_EQUAL        : u32 : 0x00030000 //!< Enable stencil test, equal.
STENCIL_TEST_GEQUAL       : u32 : 0x00040000 //!< Enable stencil test, greater or equal.
STENCIL_TEST_GREATER      : u32 : 0x00050000 //!< Enable stencil test, greater.
STENCIL_TEST_NOTEQUAL     : u32 : 0x00060000 //!< Enable stencil test, not equal.
STENCIL_TEST_NEVER        : u32 : 0x00070000 //!< Enable stencil test, never.
STENCIL_TEST_ALWAYS       : u32 : 0x00080000 //!< Enable stencil test, always.
STENCIL_TEST_SHIFT        :     : 16         //!< Stencil test bit shift
STENCIL_TEST_MASK         : u32 : 0x000f0000 //!< Stencil test bit mask

STENCIL_OP_FAIL_S_ZERO    : u32 : 0x00000000 //!< Zero.
STENCIL_OP_FAIL_S_KEEP    : u32 : 0x00100000 //!< Keep.
STENCIL_OP_FAIL_S_REPLACE : u32 : 0x00200000 //!< Replace.
STENCIL_OP_FAIL_S_INCR    : u32 : 0x00300000 //!< Increment and wrap.
STENCIL_OP_FAIL_S_INCRSAT : u32 : 0x00400000 //!< Increment and clamp.
STENCIL_OP_FAIL_S_DECR    : u32 : 0x00500000 //!< Decrement and wrap.
STENCIL_OP_FAIL_S_DECRSAT : u32 : 0x00600000 //!< Decrement and clamp.
STENCIL_OP_FAIL_S_INVERT  : u32 : 0x00700000 //!< Invert.
STENCIL_OP_FAIL_S_SHIFT   :     : 20         //!< Stencil operation fail bit shift
STENCIL_OP_FAIL_S_MASK    : u32 : 0x00f00000 //!< Stencil operation fail bit mask

STENCIL_OP_FAIL_Z_ZERO    : u32 : 0x00000000 //!< Zero.
STENCIL_OP_FAIL_Z_KEEP    : u32 : 0x01000000 //!< Keep.
STENCIL_OP_FAIL_Z_REPLACE : u32 : 0x02000000 //!< Replace.
STENCIL_OP_FAIL_Z_INCR    : u32 : 0x03000000 //!< Increment and wrap.
STENCIL_OP_FAIL_Z_INCRSAT : u32 : 0x04000000 //!< Increment and clamp.
STENCIL_OP_FAIL_Z_DECR    : u32 : 0x05000000 //!< Decrement and wrap.
STENCIL_OP_FAIL_Z_DECRSAT : u32 : 0x06000000 //!< Decrement and clamp.
STENCIL_OP_FAIL_Z_INVERT  : u32 : 0x07000000 //!< Invert.
STENCIL_OP_FAIL_Z_SHIFT   : u32 : 24         //!< Stencil operation depth fail bit shift
STENCIL_OP_FAIL_Z_MASK    : u32 : 0x0f000000 //!< Stencil operation depth fail bit mask

STENCIL_OP_PASS_Z_ZERO    : u32 : 0x00000000 //!< Zero.
STENCIL_OP_PASS_Z_KEEP    : u32 : 0x10000000 //!< Keep.
STENCIL_OP_PASS_Z_REPLACE : u32 : 0x20000000 //!< Replace.
STENCIL_OP_PASS_Z_INCR    : u32 : 0x30000000 //!< Increment and wrap.
STENCIL_OP_PASS_Z_INCRSAT : u32 : 0x40000000 //!< Increment and clamp.
STENCIL_OP_PASS_Z_DECR    : u32 : 0x50000000 //!< Decrement and wrap.
STENCIL_OP_PASS_Z_DECRSAT : u32 : 0x60000000 //!< Decrement and clamp.
STENCIL_OP_PASS_Z_INVERT  : u32 : 0x70000000 //!< Invert.
STENCIL_OP_PASS_Z_SHIFT   :     : 28         //!< Stencil operation depth pass bit shift
STENCIL_OP_PASS_Z_MASK    : u32 : 0xf0000000 //!< Stencil operation depth pass bit mask

CLEAR_NONE                : u16 : 0x0000 //!< No clear flags.
CLEAR_COLOR               : u16 : 0x0001 //!< Clear color.
CLEAR_DEPTH               : u16 : 0x0002 //!< Clear depth.
CLEAR_STENCIL             : u16 : 0x0004 //!< Clear stencil.
CLEAR_DISCARD_COLOR_0     : u16 : 0x0008 //!< Discard frame buffer attachment 0.
CLEAR_DISCARD_COLOR_1     : u16 : 0x0010 //!< Discard frame buffer attachment 1.
CLEAR_DISCARD_COLOR_2     : u16 : 0x0020 //!< Discard frame buffer attachment 2.
CLEAR_DISCARD_COLOR_3     : u16 : 0x0040 //!< Discard frame buffer attachment 3.
CLEAR_DISCARD_COLOR_4     : u16 : 0x0080 //!< Discard frame buffer attachment 4.
CLEAR_DISCARD_COLOR_5     : u16 : 0x0100 //!< Discard frame buffer attachment 5.
CLEAR_DISCARD_COLOR_6     : u16 : 0x0200 //!< Discard frame buffer attachment 6.
CLEAR_DISCARD_COLOR_7     : u16 : 0x0400 //!< Discard frame buffer attachment 7.
CLEAR_DISCARD_DEPTH       : u16 : 0x0800 //!< Discard frame buffer depth attachment.
CLEAR_DISCARD_STENCIL     : u16 : 0x1000 //!< Discard frame buffer stencil attachment.
CLEAR_DISCARD_COLOR_MASK :: 0 | CLEAR_DISCARD_COLOR_0 | CLEAR_DISCARD_COLOR_1 | CLEAR_DISCARD_COLOR_2 | CLEAR_DISCARD_COLOR_3 | CLEAR_DISCARD_COLOR_4 | CLEAR_DISCARD_COLOR_5 | CLEAR_DISCARD_COLOR_6 | CLEAR_DISCARD_COLOR_7

CLEAR_DISCARD_MASK :: 0 | CLEAR_DISCARD_COLOR_MASK | CLEAR_DISCARD_DEPTH | CLEAR_DISCARD_STENCIL

/**
 * Rendering state discard. When state is preserved in submit, rendering states can be discarded
 * on a finer grain.
 *
 */
DISCARD_NONE           : u8 : 0x00 //!< Preserve everything.
DISCARD_BINDINGS       : u8 : 0x01 //!< Discard texture sampler and buffer bindings.
DISCARD_INDEX_BUFFER   : u8 : 0x02 //!< Discard index buffer.
DISCARD_INSTANCE_DATA  : u8 : 0x04 //!< Discard instance data.
DISCARD_STATE          : u8 : 0x08 //!< Discard state and uniform bindings.
DISCARD_TRANSFORM      : u8 : 0x10 //!< Discard transform.
DISCARD_VERTEX_STREAMS : u8 : 0x20 //!< Discard vertex streams.
DISCARD_ALL            : u8 : 0xff //!< Discard all states.

DEBUG_NONE      : u32 : 0x00000000 //!< No debug.
DEBUG_WIREFRAME : u32 : 0x00000001 //!< Enable wireframe for all primitives.

/// Enable infinitely fast hardware test. No draw calls will be submitted to driver.
/// It's useful when profiling to quickly assess bottleneck between CPU and GPU.
DEBUG_IFH                   : u32 : 0x00000002
DEBUG_STATS                 : u32 : 0x00000004 //!< Enable statistics display.
DEBUG_TEXT                  : u32 : 0x00000008 //!< Enable debug text display.
DEBUG_PROFILER              : u32 : 0x00000010 //!< Enable profiler.

BUFFER_COMPUTE_FORMAT_8X1   : u16 : 0x0001 //!< 1 8-bit value
BUFFER_COMPUTE_FORMAT_8X2   : u16 : 0x0002 //!< 2 8-bit values
BUFFER_COMPUTE_FORMAT_8X4   : u16 : 0x0003 //!< 4 8-bit values
BUFFER_COMPUTE_FORMAT_16X1  : u16 : 0x0004 //!< 1 16-bit value
BUFFER_COMPUTE_FORMAT_16X2  : u16 : 0x0005 //!< 2 16-bit values
BUFFER_COMPUTE_FORMAT_16X4  : u16 : 0x0006 //!< 4 16-bit values
BUFFER_COMPUTE_FORMAT_32X1  : u16 : 0x0007 //!< 1 32-bit value
BUFFER_COMPUTE_FORMAT_32X2  : u16 : 0x0008 //!< 2 32-bit values
BUFFER_COMPUTE_FORMAT_32X4  : u16 : 0x0009 //!< 4 32-bit values
BUFFER_COMPUTE_FORMAT_SHIFT : u16 : 0

BUFFER_COMPUTE_FORMAT_MASK  : u16 : 0x000f

BUFFER_COMPUTE_TYPE_INT     : u16 : 0x0010 //!< Type `int`.
BUFFER_COMPUTE_TYPE_UINT    : u16 : 0x0020 //!< Type `uint`.
BUFFER_COMPUTE_TYPE_FLOAT   : u16 : 0x0030 //!< Type `float`.
BUFFER_COMPUTE_TYPE_SHIFT   : u16 : 4

BUFFER_COMPUTE_TYPE_MASK    : u16 : 0x0030

BUFFER_NONE                 : u16 : 0x0000
BUFFER_COMPUTE_READ         : u16 : 0x0100 //!< Buffer will be read by shader.
BUFFER_COMPUTE_WRITE        : u16 : 0x0200 //!< Buffer will be used for writing.
BUFFER_DRAW_INDIRECT        : u16 : 0x0400 //!< Buffer will be used for storing draw indirect commands.
BUFFER_ALLOW_RESIZE         : u16 : 0x0800 //!< Allow dynamic index/vertex buffer resize during update.
BUFFER_INDEX32              : u16 : 0x1000 //!< Index buffer contains 32-bit indices.
BUFFER_COMPUTE_READ_WRITE :: 0 | BUFFER_COMPUTE_READ | BUFFER_COMPUTE_WRITE

TEXTURE_NONE          : u64 : 0x0000000000000000
TEXTURE_MSAA_SAMPLE   : u64 : 0x0000000800000000 //!< Texture will be used for MSAA sampling.
TEXTURE_RT            : u64 : 0x0000001000000000 //!< Render target no MSAA.
TEXTURE_COMPUTE_WRITE : u64 : 0x0000100000000000 //!< Texture will be used for compute write.
TEXTURE_SRGB          : u64 : 0x0000200000000000 //!< Sample texture as sRGB.
TEXTURE_BLIT_DST      : u64 : 0x0000400000000000 //!< Texture will be used as blit destination.
TEXTURE_READ_BACK     : u64 : 0x0000800000000000 //!< Texture will be used for read back from GPU.

TEXTURE_RT_MSAA_X2    : u64 : 0x0000002000000000 //!< Render target MSAAx2 mode.
TEXTURE_RT_MSAA_X4    : u64 : 0x0000003000000000 //!< Render target MSAAx4 mode.
TEXTURE_RT_MSAA_X8    : u64 : 0x0000004000000000 //!< Render target MSAAx8 mode.
TEXTURE_RT_MSAA_X16   : u64 : 0x0000005000000000 //!< Render target MSAAx16 mode.
TEXTURE_RT_MSAA_SHIFT : u64 : 36

TEXTURE_RT_MSAA_MASK  : u64 : 0x0000007000000000

TEXTURE_RT_WRITE_ONLY : u64 : 0x0000008000000000 //!< Render target will be used for writing
TEXTURE_RT_SHIFT      : u64 : 36

TEXTURE_RT_MASK       : u64 : 0x000000f000000000

/**
 * Sampler flags.
 *
 */
SAMPLER_U_MIRROR           : u32 : 0x00000001 //!< Wrap U mode: Mirror
SAMPLER_U_CLAMP            : u32 : 0x00000002 //!< Wrap U mode: Clamp
SAMPLER_U_BORDER           : u32 : 0x00000003 //!< Wrap U mode: Border
SAMPLER_U_SHIFT            : u32 : 0

SAMPLER_U_MASK             : u32 : 0x00000003

SAMPLER_V_MIRROR           : u32 : 0x00000004 //!< Wrap V mode: Mirror
SAMPLER_V_CLAMP            : u32 : 0x00000008 //!< Wrap V mode: Clamp
SAMPLER_V_BORDER           : u32 : 0x0000000c //!< Wrap V mode: Border
SAMPLER_V_SHIFT            : u32 : 2

SAMPLER_V_MASK             : u32 : 0x0000000c

SAMPLER_W_MIRROR           : u32 : 0x00000010 //!< Wrap W mode: Mirror
SAMPLER_W_CLAMP            : u32 : 0x00000020 //!< Wrap W mode: Clamp
SAMPLER_W_BORDER           : u32 : 0x00000030 //!< Wrap W mode: Border
SAMPLER_W_SHIFT            : u32 : 4

SAMPLER_W_MASK             : u32 : 0x00000030

SAMPLER_MIN_POINT          : u32 : 0x00000040 //!< Min sampling mode: Point
SAMPLER_MIN_ANISOTROPIC    : u32 : 0x00000080 //!< Min sampling mode: Anisotropic
SAMPLER_MIN_SHIFT          : u32 : 6

SAMPLER_MIN_MASK           : u32 : 0x000000c0

SAMPLER_MAG_POINT          : u32 : 0x00000100 //!< Mag sampling mode: Point
SAMPLER_MAG_ANISOTROPIC    : u32 : 0x00000200 //!< Mag sampling mode: Anisotropic
SAMPLER_MAG_SHIFT          : u32 : 8

SAMPLER_MAG_MASK           : u32 : 0x00000300

SAMPLER_MIP_POINT          : u32 : 0x00000400 //!< Mip sampling mode: Point
SAMPLER_MIP_SHIFT          : u32 : 10

SAMPLER_MIP_MASK           : u32 : 0x00000400

SAMPLER_COMPARE_LESS       : u32 : 0x00010000 //!< Compare when sampling depth texture: less.
SAMPLER_COMPARE_LEQUAL     : u32 : 0x00020000 //!< Compare when sampling depth texture: less or equal.
SAMPLER_COMPARE_EQUAL      : u32 : 0x00030000 //!< Compare when sampling depth texture: equal.
SAMPLER_COMPARE_GEQUAL     : u32 : 0x00040000 //!< Compare when sampling depth texture: greater or equal.
SAMPLER_COMPARE_GREATER    : u32 : 0x00050000 //!< Compare when sampling depth texture: greater.
SAMPLER_COMPARE_NOTEQUAL   : u32 : 0x00060000 //!< Compare when sampling depth texture: not equal.
SAMPLER_COMPARE_NEVER      : u32 : 0x00070000 //!< Compare when sampling depth texture: never.
SAMPLER_COMPARE_ALWAYS     : u32 : 0x00080000 //!< Compare when sampling depth texture: always.
SAMPLER_COMPARE_SHIFT      : u32 : 16

SAMPLER_COMPARE_MASK       : u32 : 0x000f0000

SAMPLER_BORDER_COLOR_SHIFT : u32 : 24

SAMPLER_BORDER_COLOR_MASK  : u32 : 0x0f000000
SAMPLER_BORDER_COLOR :: #force_inline proc "contextless" (v: u32) -> u32 { return (v << SAMPLER_BORDER_COLOR_SHIFT) & SAMPLER_BORDER_COLOR_MASK }

SAMPLER_RESERVED_SHIFT     : u32 : 28

SAMPLER_RESERVED_MASK      : u32 : 0xf0000000

SAMPLER_NONE               : u32 : 0x00000000
SAMPLER_SAMPLE_STENCIL     : u32 : 0x00100000 //!< Sample stencil instead of depth.
SAMPLER_POINT      :: 0 | SAMPLER_MIN_POINT | SAMPLER_MAG_POINT | SAMPLER_MIP_POINT
SAMPLER_UVW_MIRROR :: 0 | SAMPLER_U_MIRROR | SAMPLER_V_MIRROR | SAMPLER_W_MIRROR
SAMPLER_UVW_CLAMP  :: 0 | SAMPLER_U_CLAMP | SAMPLER_V_CLAMP | SAMPLER_W_CLAMP
SAMPLER_UVW_BORDER :: 0 | SAMPLER_U_BORDER | SAMPLER_V_BORDER | SAMPLER_W_BORDER
SAMPLER_BITS_MASK  :: 0 | SAMPLER_U_MASK | SAMPLER_V_MASK | SAMPLER_W_MASK | SAMPLER_MIN_MASK | SAMPLER_MAG_MASK | SAMPLER_MIP_MASK | SAMPLER_COMPARE_MASK

RESET_MSAA_X2            : u32 : 0x00000010 //!< Enable 2x MSAA.
RESET_MSAA_X4            : u32 : 0x00000020 //!< Enable 4x MSAA.
RESET_MSAA_X8            : u32 : 0x00000030 //!< Enable 8x MSAA.
RESET_MSAA_X16           : u32 : 0x00000040 //!< Enable 16x MSAA.
RESET_MSAA_SHIFT         : u32 : 4

RESET_MSAA_MASK          : u32 : 0x00000070

RESET_NONE               : u32 : 0x00000000 //!< No reset flags.
RESET_FULLSCREEN         : u32 : 0x00000001 //!< Not supported yet.
RESET_VSYNC              : u32 : 0x00000080 //!< Enable V-Sync.
RESET_MAXANISOTROPY      : u32 : 0x00000100 //!< Turn on/off max anisotropy.
RESET_CAPTURE            : u32 : 0x00000200 //!< Begin screen capture.
RESET_FLUSH_AFTER_RENDER : u32 : 0x00002000 //!< Flush rendering after submitting to GPU.

/// This flag specifies where flip occurs. Default behaviour is that flip occurs
/// before rendering new frame. This flag only has effect when `BGFX_CONFIG_MULTITHREADED=0`.
RESET_FLIP_AFTER_RENDER       : u32 : 0x00004000
RESET_SRGB_BACKBUFFER         : u32 : 0x00008000 //!< Enable sRGB backbuffer.
RESET_HDR10                   : u32 : 0x00010000 //!< Enable HDR10 rendering.
RESET_HIDPI                   : u32 : 0x00020000 //!< Enable HiDPI rendering.
RESET_DEPTH_CLAMP             : u32 : 0x00040000 //!< Enable depth clamp.
RESET_SUSPEND                 : u32 : 0x00080000 //!< Suspend rendering.

RESET_FULLSCREEN_SHIFT        : u32 : 0

RESET_FULLSCREEN_MASK         : u32 : 0x00000001

RESET_RESERVED_SHIFT          : u32 : 31                   //!< Internal bit shift
RESET_RESERVED_MASK           : u32 : 0x80000000 //!< Internal bit mask

CAPS_ALPHA_TO_COVERAGE        : u64 : 0x0000000000000001 //!< Alpha to coverage is supported.
CAPS_BLEND_INDEPENDENT        : u64 : 0x0000000000000002 //!< Blend independent is supported.
CAPS_COMPUTE                  : u64 : 0x0000000000000004 //!< Compute shaders are supported.
CAPS_CONSERVATIVE_RASTER      : u64 : 0x0000000000000008 //!< Conservative rasterization is supported.
CAPS_DRAW_INDIRECT            : u64 : 0x0000000000000010 //!< Draw indirect is supported.
CAPS_FRAGMENT_DEPTH           : u64 : 0x0000000000000020 //!< Fragment depth is available in fragment shader.
CAPS_FRAGMENT_ORDERING        : u64 : 0x0000000000000040 //!< Fragment ordering is available in fragment shader.
CAPS_GRAPHICS_DEBUGGER        : u64 : 0x0000000000000080 //!< Graphics debugger is present.
CAPS_HDR10                    : u64 : 0x0000000000000100 //!< HDR10 rendering is supported.
CAPS_HIDPI                    : u64 : 0x0000000000000200 //!< HiDPI rendering is supported.
CAPS_IMAGE_RW                 : u64 : 0x0000000000000400 //!< Image Read/Write is supported.
CAPS_INDEX32                  : u64 : 0x0000000000000800 //!< 32-bit indices are supported.
CAPS_INSTANCING               : u64 : 0x0000000000001000 //!< Instancing is supported.
CAPS_OCCLUSION_QUERY          : u64 : 0x0000000000002000 //!< Occlusion query is supported.
CAPS_RENDERER_MULTITHREADED   : u64 : 0x0000000000004000 //!< Renderer is on separate thread.
CAPS_SWAP_CHAIN               : u64 : 0x0000000000008000 //!< Multiple windows are supported.
CAPS_TEXTURE_2D_ARRAY         : u64 : 0x0000000000010000 //!< 2D texture array is supported.
CAPS_TEXTURE_3D               : u64 : 0x0000000000020000 //!< 3D textures are supported.
CAPS_TEXTURE_BLIT             : u64 : 0x0000000000040000 //!< Texture blit is supported.
CAPS_TEXTURE_COMPARE_RESERVED : u64 : 0x0000000000080000
CAPS_TEXTURE_COMPARE_LEQUAL   : u64 : 0x0000000000100000 //!< Texture compare less equal mode is supported.
CAPS_TEXTURE_CUBE_ARRAY       : u64 : 0x0000000000200000 //!< Cubemap texture array is supported.
CAPS_TEXTURE_DIRECT_ACCESS    : u64 : 0x0000000000400000 //!< CPU direct access to GPU texture memory.
CAPS_TEXTURE_READ_BACK        : u64 : 0x0000000000800000 //!< Read-back texture is supported.
CAPS_VERTEX_ATTRIB_HALF       : u64 : 0x0000000001000000 //!< Vertex attribute half-float is supported.
CAPS_VERTEX_ATTRIB_UINT10     : u64 : 0x0000000002000000 //!< Vertex attribute 10_10_10_2 is supported.
CAPS_VERTEX_ID                : u64 : 0x0000000004000000 //!< Rendering with VertexID only is supported.
CAPS_VIEWPORT_LAYER_ARRAY     : u64 : 0x0000000008000000 //!< Viewport layer is available in vertex shader.
/// All texture compare modes are supported.
CAPS_TEXTURE_COMPARE_ALL :: 0 | CAPS_TEXTURE_COMPARE_RESERVED | CAPS_TEXTURE_COMPARE_LEQUAL

CAPS_FORMAT_TEXTURE_NONE             : u32 : 0x00000000 //!< Texture format is not supported.
CAPS_FORMAT_TEXTURE_2D               : u32 : 0x00000001 //!< Texture format is supported.
CAPS_FORMAT_TEXTURE_2D_SRGB          : u32 : 0x00000002 //!< Texture as sRGB format is supported.
CAPS_FORMAT_TEXTURE_2D_EMULATED      : u32 : 0x00000004 //!< Texture format is emulated.
CAPS_FORMAT_TEXTURE_3D               : u32 : 0x00000008 //!< Texture format is supported.
CAPS_FORMAT_TEXTURE_3D_SRGB          : u32 : 0x00000010 //!< Texture as sRGB format is supported.
CAPS_FORMAT_TEXTURE_3D_EMULATED      : u32 : 0x00000020 //!< Texture format is emulated.
CAPS_FORMAT_TEXTURE_CUBE             : u32 : 0x00000040 //!< Texture format is supported.
CAPS_FORMAT_TEXTURE_CUBE_SRGB        : u32 : 0x00000080 //!< Texture as sRGB format is supported.
CAPS_FORMAT_TEXTURE_CUBE_EMULATED    : u32 : 0x00000100 //!< Texture format is emulated.
CAPS_FORMAT_TEXTURE_VERTEX           : u32 : 0x00000200 //!< Texture format can be used from vertex shader.
CAPS_FORMAT_TEXTURE_IMAGE_READ       : u32 : 0x00000400 //!< Texture format can be used as image and read from.
CAPS_FORMAT_TEXTURE_IMAGE_WRITE      : u32 : 0x00000800 //!< Texture format can be used as image and written to.
CAPS_FORMAT_TEXTURE_FRAMEBUFFER      : u32 : 0x00001000 //!< Texture format can be used as frame buffer.
CAPS_FORMAT_TEXTURE_FRAMEBUFFER_MSAA : u32 : 0x00002000 //!< Texture format can be used as MSAA frame buffer.
CAPS_FORMAT_TEXTURE_MSAA             : u32 : 0x00004000 //!< Texture can be sampled as MSAA.
CAPS_FORMAT_TEXTURE_MIP_AUTOGEN      : u32 : 0x00008000 //!< Texture format supports auto-generated mips.

RESOLVE_NONE                         : u8 : 0x00 //!< No resolve flags.
RESOLVE_AUTO_GEN_MIPS                : u8 : 0x01 //!< Auto-generate mip maps on resolve.

PCI_ID_NONE                          : u16 : 0x0000 //!< Autoselect adapter.
PCI_ID_SOFTWARE_RASTERIZER           : u16 : 0x0001 //!< Software rasterizer.
PCI_ID_AMD                           : u16 : 0x1002 //!< AMD adapter.
PCI_ID_INTEL                         : u16 : 0x8086 //!< Intel adapter.
PCI_ID_NVIDIA                        : u16 : 0x10de //!< nVidia adapter.

CUBE_MAP_POSITIVE_X                  : u8 : 0x00 //!< Cubemap +x.
CUBE_MAP_NEGATIVE_X                  : u8 : 0x01 //!< Cubemap -x.
CUBE_MAP_POSITIVE_Y                  : u8 : 0x02 //!< Cubemap +y.
CUBE_MAP_NEGATIVE_Y                  : u8 : 0x03 //!< Cubemap -y.
CUBE_MAP_POSITIVE_Z                  : u8 : 0x04 //!< Cubemap +z.
CUBE_MAP_NEGATIVE_Z                  : u8 : 0x05 //!< Cubemap -z.
/// Blend function separate.
STATE_BLEND_FUNC_SEPARATE :: #force_inline proc "contextless" (_srcRGB, _dstRGB, _srcA, _dstA: u64) -> u64 {
    return 0 | (_srcRGB | (_dstRGB << 4)) | (( _srcA | (_dstA << 4)) << 8)                      
}

/// Blend equation separate.
STATE_BLEND_EQUATION_SEPARATE :: #force_inline proc "contextless" (_equationRGB, _equationA: u64) -> u64 { return _equationRGB | (_equationA << 3) }

/// Blend function.
STATE_BLEND_FUNC :: #force_inline proc "contextless" (_src, _dst: u64) -> u64 { return STATE_BLEND_FUNC_SEPARATE(_src, _dst, _src, _dst) }

/// Blend equation.
STATE_BLEND_EQUATION :: #force_inline proc "contextless" (_equation: u64) -> u64 { return STATE_BLEND_EQUATION_SEPARATE(_equation, _equation) }

/// Utility predefined blend modes.

/// Additive blending.
STATE_BLEND_ADD :: #force_inline proc "contextless" () -> u64 { return 0 | STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_ONE) }

/// Alpha blend.
STATE_BLEND_ALPHA :: #force_inline proc "contextless" () -> u64 { return 0 | STATE_BLEND_FUNC(STATE_BLEND_SRC_ALPHA, STATE_BLEND_INV_SRC_ALPHA) }

/// Selects darker color of blend.
STATE_BLEND_DARKEN :: #force_inline proc "contextless" () -> u64 { return 0 | STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_ONE) | STATE_BLEND_EQUATION(STATE_BLEND_EQUATION_MIN) }

/// Selects lighter color of blend.
STATE_BLEND_LIGHTEN :: #force_inline proc "contextless" () -> u64 { return 0 | STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_ONE) | STATE_BLEND_EQUATION(STATE_BLEND_EQUATION_MAX) }

/// Multiplies colors.
STATE_BLEND_MULTIPLY :: #force_inline proc "contextless" () -> u64 { return 0 | STATE_BLEND_FUNC(STATE_BLEND_DST_COLOR, STATE_BLEND_ZERO) }

/// Opaque pixels will cover the pixels directly below them without any math or algorithm applied to them.
STATE_BLEND_NORMAL :: #force_inline proc "contextless" () -> u64 { return 0 | STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_INV_SRC_ALPHA) }

/// Multiplies the inverse of the blend and base colors.
STATE_BLEND_SCREEN :: #force_inline proc "contextless" () -> u64 { return 0 | STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_INV_SRC_COLOR) }

/// Decreases the brightness of the base color based on the value of the blend color.
STATE_BLEND_LINEAR_BURN :: #force_inline proc "contextless" () -> u64 { return 0 | STATE_BLEND_FUNC(STATE_BLEND_DST_COLOR, STATE_BLEND_INV_DST_COLOR) | STATE_BLEND_EQUATION(STATE_BLEND_EQUATION_SUB)  }

STATE_BLEND_FUNC_RT_x :: #force_inline proc "contextless" (_src, _dst: u32) -> u32 { return 0 | (_src >> STATE_BLEND_SHIFT) | ((_dst >> STATE_BLEND_SHIFT) << 4) }

STATE_BLEND_FUNC_RT_xE :: #force_inline proc "contextless" (_src, _dst, _equation: u32) -> u32 { return 0 | STATE_BLEND_FUNC_RT_x(_src, _dst) | ((_equation >> STATE_BLEND_EQUATION_SHIFT) << 8) }

STATE_BLEND_FUNC_RT_1 :: #force_inline proc "contextless" (_src, _dst: u32) -> u32 { return STATE_BLEND_FUNC_RT_x(_src, _dst) << 0  }
STATE_BLEND_FUNC_RT_2 :: #force_inline proc "contextless" (_src, _dst: u32) -> u32 { return STATE_BLEND_FUNC_RT_x(_src, _dst) << 11 }
STATE_BLEND_FUNC_RT_3 :: #force_inline proc "contextless" (_src, _dst: u32) -> u32 { return STATE_BLEND_FUNC_RT_x(_src, _dst) << 22 }

STATE_BLEND_FUNC_RT_1E :: #force_inline proc "contextless" (_src, _dst, _equation: u32) -> u32 { return STATE_BLEND_FUNC_RT_xE(_src, _dst, _equation) << 0  }
STATE_BLEND_FUNC_RT_2E :: #force_inline proc "contextless" (_src, _dst, _equation: u32) -> u32 { return STATE_BLEND_FUNC_RT_xE(_src, _dst, _equation) << 11 }
STATE_BLEND_FUNC_RT_3E :: #force_inline proc "contextless" (_src, _dst, _equation: u32) -> u32 { return STATE_BLEND_FUNC_RT_xE(_src, _dst, _equation) << 22 }
