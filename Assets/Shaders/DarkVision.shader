Shader "Custom/DarkVision"
{
    Properties
    {
        // Versioning of material to help for upgrading
        [HideInInspector] _HdrpVersion("_HdrpVersion", Float) = 2

        // Following set of parameters represent the parameters node inside the MaterialGraph.
        // They are use to fill a SurfaceData. With a MaterialGraph this should not exist.

        // Reminder. Color here are in linear but the UI (color picker) do the conversion sRGB to linear
        _BaseColor("BaseColor", Color) = (1,1,1,1)
        _BaseColorMap("BaseColorMap", 2D) = "white" {}
        [HideInInspector] _BaseColorMap_MipInfo("_BaseColorMap_MipInfo", Vector) = (0, 0, 0, 0)

        _Metallic("_Metallic", Range(0.0, 1.0)) = 0
        _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
        _MaskMap("MaskMap", 2D) = "white" {}
        _SmoothnessRemapMin("SmoothnessRemapMin", Float) = 0.0
        _SmoothnessRemapMax("SmoothnessRemapMax", Float) = 1.0
        _AORemapMin("AORemapMin", Float) = 0.0
        _AORemapMax("AORemapMax", Float) = 1.0

        _NormalMap("NormalMap", 2D) = "bump" {}     // Tangent space normal map
        _NormalMapOS("NormalMapOS", 2D) = "white" {} // Object space normal map - no good default value
        _NormalScale("_NormalScale", Range(0.0, 8.0)) = 1

        _BentNormalMap("_BentNormalMap", 2D) = "bump" {}
        _BentNormalMapOS("_BentNormalMapOS", 2D) = "white" {}

        _HeightMap("HeightMap", 2D) = "black" {}
        // Caution: Default value of _HeightAmplitude must be (_HeightMax - _HeightMin) * 0.01
        // Those two properties are computed from the ones exposed in the UI and depends on the displaement mode so they are separate because we don't want to lose information upon displacement mode change.
        [HideInInspector] _HeightAmplitude("Height Amplitude", Float) = 0.02 // In world units. This will be computed in the UI.
        [HideInInspector] _HeightCenter("Height Center", Range(0.0, 1.0)) = 0.5 // In texture space

        [Enum(MinMax, 0, Amplitude, 1)] _HeightMapParametrization("Heightmap Parametrization", Int) = 0
            // These parameters are for vertex displacement/Tessellation
            _HeightOffset("Height Offset", Float) = 0
            // MinMax mode
            _HeightMin("Heightmap Min", Float) = -1
            _HeightMax("Heightmap Max", Float) = 1
            // Amplitude mode
            _HeightTessAmplitude("Amplitude", Float) = 2.0 // in Centimeters
            _HeightTessCenter("Height Center", Range(0.0, 1.0)) = 0.5 // In texture space

            // These parameters are for pixel displacement
            _HeightPoMAmplitude("Height Amplitude", Float) = 2.0 // In centimeters

            _DetailMap("DetailMap", 2D) = "linearGrey" {}
            _DetailAlbedoScale("_DetailAlbedoScale", Range(0.0, 2.0)) = 1
            _DetailNormalScale("_DetailNormalScale", Range(0.0, 2.0)) = 1
            _DetailSmoothnessScale("_DetailSmoothnessScale", Range(0.0, 2.0)) = 1

            _TangentMap("TangentMap", 2D) = "bump" {}
            _TangentMapOS("TangentMapOS", 2D) = "white" {}
            _Anisotropy("Anisotropy", Range(-1.0, 1.0)) = 0
            _AnisotropyMap("AnisotropyMap", 2D) = "white" {}

            _SubsurfaceMask("Subsurface Radius", Range(0.0, 1.0)) = 1.0
            _SubsurfaceMaskMap("Subsurface Radius Map", 2D) = "white" {}
            _Thickness("Thickness", Range(0.0, 1.0)) = 1.0
            _ThicknessMap("Thickness Map", 2D) = "white" {}
            _ThicknessRemap("Thickness Remap", Vector) = (0, 1, 0, 0)

            _IridescenceThickness("Iridescence Thickness", Range(0.0, 1.0)) = 1.0
            _IridescenceThicknessMap("Iridescence Thickness Map", 2D) = "white" {}
            _IridescenceThicknessRemap("Iridescence Thickness Remap", Vector) = (0, 1, 0, 0)
            _IridescenceMask("Iridescence Mask", Range(0.0, 1.0)) = 1.0
            _IridescenceMaskMap("Iridescence Mask Map", 2D) = "white" {}

            _CoatMask("Coat Mask", Range(0.0, 1.0)) = 0.0
            _CoatMaskMap("CoatMaskMap", 2D) = "white" {}

            [ToggleUI] _EnergyConservingSpecularColor("_EnergyConservingSpecularColor", Float) = 1.0
            _SpecularColor("SpecularColor", Color) = (1, 1, 1, 1)
            _SpecularColorMap("SpecularColorMap", 2D) = "white" {}

            // Following options are for the GUI inspector and different from the input parameters above
            // These option below will cause different compilation flag.
            [Enum(Off, 0, From Ambient Occlusion, 1, From Bent Normals, 2)]  _SpecularOcclusionMode("Specular Occlusion Mode", Int) = 1

            [HDR] _EmissiveColor("EmissiveColor", Color) = (0, 0, 0)
                // Used only to serialize the LDR and HDR emissive color in the material UI,
                // in the shader only the _EmissiveColor should be used
                [HideInInspector] _EmissiveColorLDR("EmissiveColor LDR", Color) = (0, 0, 0)
                _EmissiveColorMap("EmissiveColorMap", 2D) = "white" {}
                [ToggleUI] _AlbedoAffectEmissive("Albedo Affect Emissive", Float) = 0.0
                [HideInInspector] _EmissiveIntensityUnit("Emissive Mode", Int) = 0
                [ToggleUI] _UseEmissiveIntensity("Use Emissive Intensity", Int) = 0
                _EmissiveIntensity("Emissive Intensity", Float) = 1
                _EmissiveExposureWeight("Emissive Pre Exposure", Range(0.0, 1.0)) = 1.0

                _DistortionVectorMap("DistortionVectorMap", 2D) = "black" {}
                [ToggleUI] _DistortionEnable("Enable Distortion", Float) = 0.0
                [ToggleUI] _DistortionDepthTest("Distortion Depth Test Enable", Float) = 1.0
                [Enum(Add, 0, Multiply, 1, Replace, 2)] _DistortionBlendMode("Distortion Blend Mode", Int) = 0
                [HideInInspector] _DistortionSrcBlend("Distortion Blend Src", Int) = 0
                [HideInInspector] _DistortionDstBlend("Distortion Blend Dst", Int) = 0
                [HideInInspector] _DistortionBlurSrcBlend("Distortion Blur Blend Src", Int) = 0
                [HideInInspector] _DistortionBlurDstBlend("Distortion Blur Blend Dst", Int) = 0
                [HideInInspector] _DistortionBlurBlendMode("Distortion Blur Blend Mode", Int) = 0
                _DistortionScale("Distortion Scale", Float) = 1
                _DistortionVectorScale("Distortion Vector Scale", Float) = 2
                _DistortionVectorBias("Distortion Vector Bias", Float) = -1
                _DistortionBlurScale("Distortion Blur Scale", Float) = 1
                _DistortionBlurRemapMin("DistortionBlurRemapMin", Float) = 0.0
                _DistortionBlurRemapMax("DistortionBlurRemapMax", Float) = 1.0


                [ToggleUI]  _UseShadowThreshold("_UseShadowThreshold", Float) = 0.0
                [ToggleUI]  _AlphaCutoffEnable("Alpha Cutoff Enable", Float) = 0.0
                _AlphaCutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
                _AlphaCutoffShadow("_AlphaCutoffShadow", Range(0.0, 1.0)) = 0.5
                _AlphaCutoffPrepass("_AlphaCutoffPrepass", Range(0.0, 1.0)) = 0.5
                _AlphaCutoffPostpass("_AlphaCutoffPostpass", Range(0.0, 1.0)) = 0.5
                [ToggleUI] _TransparentDepthPrepassEnable("_TransparentDepthPrepassEnable", Float) = 0.0
                [ToggleUI] _TransparentBackfaceEnable("_TransparentBackfaceEnable", Float) = 0.0
                [ToggleUI] _TransparentDepthPostpassEnable("_TransparentDepthPostpassEnable", Float) = 0.0
                _TransparentSortPriority("_TransparentSortPriority", Float) = 0

                    // Transparency
                    [Enum(None, 0, Box, 1, Sphere, 2, Thin, 3)]_RefractionModel("Refraction Model", Int) = 0
                    [Enum(Proxy, 1, HiZ, 2)]_SSRefractionProjectionModel("Refraction Projection Model", Int) = 0
                    _Ior("Index Of Refraction", Range(1.0, 2.5)) = 1.5
                    _TransmittanceColor("Transmittance Color", Color) = (1.0, 1.0, 1.0)
                    _TransmittanceColorMap("TransmittanceColorMap", 2D) = "white" {}
                    _ATDistance("Transmittance Absorption Distance", Float) = 1.0
                    [ToggleUI] _TransparentWritingMotionVec("_TransparentWritingMotionVec", Float) = 0.0

                        // Stencil state

                        // Forward
                        [HideInInspector] _StencilRef("_StencilRef", Int) = 2 // StencilLightingUsage.RegularLighting
                        [HideInInspector] _StencilWriteMask("_StencilWriteMask", Int) = 3 // StencilMask.Lighting
                        // GBuffer
                        [HideInInspector] _StencilRefGBuffer("_StencilRefGBuffer", Int) = 2 // StencilLightingUsage.RegularLighting
                        [HideInInspector] _StencilWriteMaskGBuffer("_StencilWriteMaskGBuffer", Int) = 3 // StencilMask.Lighting
                        // Depth prepass
                        [HideInInspector] _StencilRefDepth("_StencilRefDepth", Int) = 0 // Nothing
                        [HideInInspector] _StencilWriteMaskDepth("_StencilWriteMaskDepth", Int) = 32 // DoesntReceiveSSR
                        // Motion vector pass
                        [HideInInspector] _StencilRefMV("_StencilRefMV", Int) = 128 // StencilBitMask.ObjectMotionVectors
                        [HideInInspector] _StencilWriteMaskMV("_StencilWriteMaskMV", Int) = 128 // StencilBitMask.ObjectMotionVectors
                        // Distortion vector pass
                        [HideInInspector] _StencilRefDistortionVec("_StencilRefDistortionVec", Int) = 64 // StencilBitMask.DistortionVectors
                        [HideInInspector] _StencilWriteMaskDistortionVec("_StencilWriteMaskDistortionVec", Int) = 64 // StencilBitMask.DistortionVectors

                        // Blending state
                        [HideInInspector] _SurfaceType("__surfacetype", Float) = 0.0
                        [HideInInspector] _BlendMode("__blendmode", Float) = 0.0
                        [HideInInspector] _SrcBlend("__src", Float) = 1.0
                        [HideInInspector] _DstBlend("__dst", Float) = 0.0
                        [HideInInspector] _AlphaSrcBlend("__alphaSrc", Float) = 1.0
                        [HideInInspector] _AlphaDstBlend("__alphaDst", Float) = 0.0
                        [HideInInspector][ToggleUI] _ZWrite("__zw", Float) = 1.0
                        [HideInInspector] _CullMode("__cullmode", Float) = 2.0
                        [HideInInspector] _CullModeForward("__cullmodeForward", Float) = 2.0 // This mode is dedicated to Forward to correctly handle backface then front face rendering thin transparent
                        [Enum(UnityEditor.Rendering.HighDefinition.TransparentCullMode)] _TransparentCullMode("_TransparentCullMode", Int) = 2 // Back culling by default
                        [HideInInspector] _ZTestDepthEqualForOpaque("_ZTestDepthEqualForOpaque", Int) = 4 // Less equal
                        [HideInInspector] _ZTestModeDistortion("_ZTestModeDistortion", Int) = 8
                        [HideInInspector] _ZTestGBuffer("_ZTestGBuffer", Int) = 4
                        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTestTransparent("Transparent ZTest", Int) = 4 // Less equal

                        [ToggleUI] _EnableFogOnTransparent("Enable Fog", Float) = 1.0
                        [ToggleUI] _EnableBlendModePreserveSpecularLighting("Enable Blend Mode Preserve Specular Lighting", Float) = 1.0

                        [ToggleUI] _DoubleSidedEnable("Double sided enable", Float) = 0.0
                        [Enum(Flip, 0, Mirror, 1, None, 2)] _DoubleSidedNormalMode("Double sided normal mode", Float) = 1
                        [HideInInspector] _DoubleSidedConstants("_DoubleSidedConstants", Vector) = (1, 1, -1, 0)

                        [Enum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Planar, 4, Triplanar, 5)] _UVBase("UV Set for base", Float) = 0
                        _TexWorldScale("Scale to apply on world coordinate", Float) = 1.0
                        [HideInInspector] _InvTilingScale("Inverse tiling scale = 2 / (abs(_BaseColorMap_ST.x) + abs(_BaseColorMap_ST.y))", Float) = 1
                        [HideInInspector] _UVMappingMask("_UVMappingMask", Color) = (1, 0, 0, 0)
                        [Enum(TangentSpace, 0, ObjectSpace, 1)] _NormalMapSpace("NormalMap space", Float) = 0

                        // Following enum should be material feature flags (i.e bitfield), however due to Gbuffer encoding constrain many combination exclude each other
                        // so we use this enum as "material ID" which can be interpreted as preset of bitfield of material feature
                        // The only material feature flag that can be added in all cases is clear coat
                        [Enum(Subsurface Scattering, 0, Standard, 1, Anisotropy, 2, Iridescence, 3, Specular Color, 4, Translucent, 5)] _MaterialID("MaterialId", Int) = 1 // MaterialId.Standard
                        [ToggleUI] _TransmissionEnable("_TransmissionEnable", Float) = 1.0

                        [Enum(None, 0, Vertex displacement, 1, Pixel displacement, 2)] _DisplacementMode("DisplacementMode", Int) = 0
                        [ToggleUI] _DisplacementLockObjectScale("displacement lock object scale", Float) = 1.0
                        [ToggleUI] _DisplacementLockTilingScale("displacement lock tiling scale", Float) = 1.0
                        [ToggleUI] _DepthOffsetEnable("Depth Offset View space", Float) = 0.0

                        [ToggleUI] _EnableGeometricSpecularAA("EnableGeometricSpecularAA", Float) = 0.0
                        _SpecularAAScreenSpaceVariance("SpecularAAScreenSpaceVariance", Range(0.0, 1.0)) = 0.1
                        _SpecularAAThreshold("SpecularAAThreshold", Range(0.0, 1.0)) = 0.2

                        _PPDMinSamples("Min sample for POM", Range(1.0, 64.0)) = 5
                        _PPDMaxSamples("Max sample for POM", Range(1.0, 64.0)) = 15
                        _PPDLodThreshold("Start lod to fade out the POM effect", Range(0.0, 16.0)) = 5
                        _PPDPrimitiveLength("Primitive length for POM", Float) = 1
                        _PPDPrimitiveWidth("Primitive width for POM", Float) = 1
                        [HideInInspector] _InvPrimScale("Inverse primitive scale for non-planar POM", Vector) = (1, 1, 0, 0)

                        [Enum(UV0, 0, UV1, 1, UV2, 2, UV3, 3)] _UVDetail("UV Set for detail", Float) = 0
                        [HideInInspector] _UVDetailsMappingMask("_UVDetailsMappingMask", Color) = (1, 0, 0, 0)
                        [ToggleUI] _LinkDetailsWithBase("LinkDetailsWithBase", Float) = 1.0

                        [Enum(Use Emissive Color, 0, Use Emissive Mask, 1)] _EmissiveColorMode("Emissive color mode", Float) = 1
                        [Enum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Planar, 4, Triplanar, 5)] _UVEmissive("UV Set for emissive", Float) = 0
                        _TexWorldScaleEmissive("Scale to apply on world coordinate", Float) = 1.0
                        [HideInInspector] _UVMappingMaskEmissive("_UVMappingMaskEmissive", Color) = (1, 0, 0, 0)

                        // Caution: C# code in BaseLitUI.cs call LightmapEmissionFlagsProperty() which assume that there is an existing "_EmissionColor"
                        // value that exist to identify if the GI emission need to be enabled.
                        // In our case we don't use such a mechanism but need to keep the code quiet. We declare the value and always enable it.
                        // TODO: Fix the code in legacy unity so we can customize the beahvior for GI
                        _EmissionColor("Color", Color) = (1, 1, 1)

                        // HACK: GI Baking system relies on some properties existing in the shader ("_MainTex", "_Cutoff" and "_Color") for opacity handling, so we need to store our version of those parameters in the hard-coded name the GI baking system recognizes.
                        _MainTex("Albedo", 2D) = "white" {}
                        _Color("Color", Color) = (1,1,1,1)
                        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

                        [ToggleUI] _SupportDecals("Support Decals", Float) = 1.0
                        [ToggleUI] _ReceivesSSR("Receives SSR", Float) = 1.0
                        [ToggleUI] _AddPrecomputedVelocity("AddPrecomputedVelocity", Float) = 0.0

                        [HideInInspector] _DiffusionProfile("Obsolete, kept for migration purpose", Int) = 0
                        [HideInInspector] _DiffusionProfileAsset("Diffusion Profile Asset", Vector) = (0, 0, 0, 0)
                        [HideInInspector] _DiffusionProfileHash("Diffusion Profile Hash", Float) = 0
    }

        HLSLINCLUDE
#define DARK_VISION_CUT_LENGTH 6.0f
#pragma target 4.5
#pragma only_renderers d3d11 ps4 xboxone vulkan metal switch

                            //-------------------------------------------------------------------------------------
                            // Variant
                            //-------------------------------------------------------------------------------------

#pragma shader_feature_local _ALPHATEST_ON
#pragma shader_feature_local _DEPTHOFFSET_ON
#pragma shader_feature_local _DOUBLESIDED_ON
#pragma shader_feature_local _ _VERTEX_DISPLACEMENT _PIXEL_DISPLACEMENT
#pragma shader_feature_local _VERTEX_DISPLACEMENT_LOCK_OBJECT_SCALE
#pragma shader_feature_local _DISPLACEMENT_LOCK_TILING_SCALE
#pragma shader_feature_local _PIXEL_DISPLACEMENT_LOCK_OBJECT_SCALE
#pragma shader_feature_local _ _REFRACTION_PLANE _REFRACTION_SPHERE

#pragma shader_feature_local _ _EMISSIVE_MAPPING_PLANAR _EMISSIVE_MAPPING_TRIPLANAR
#pragma shader_feature_local _ _MAPPING_PLANAR _MAPPING_TRIPLANAR
#pragma shader_feature_local _NORMALMAP_TANGENT_SPACE
#pragma shader_feature_local _ _REQUIRE_UV2 _REQUIRE_UV3

#pragma shader_feature_local _NORMALMAP
#pragma shader_feature_local _MASKMAP
#pragma shader_feature_local _BENTNORMALMAP
#pragma shader_feature_local _EMISSIVE_COLOR_MAP

// _ENABLESPECULAROCCLUSION keyword is obsolete but keep here for compatibility. Do not used
// _ENABLESPECULAROCCLUSION and _SPECULAR_OCCLUSION_X can't exist at the same time (the new _SPECULAR_OCCLUSION replace it)
// When _ENABLESPECULAROCCLUSION is found we define _SPECULAR_OCCLUSION_X so new code to work
#pragma shader_feature_local _ENABLESPECULAROCCLUSION
#pragma shader_feature_local _ _SPECULAR_OCCLUSION_NONE _SPECULAR_OCCLUSION_FROM_BENT_NORMAL_MAP
#ifdef _ENABLESPECULAROCCLUSION
#define _SPECULAR_OCCLUSION_FROM_BENT_NORMAL_MAP
#endif

#pragma shader_feature_local _HEIGHTMAP
#pragma shader_feature_local _TANGENTMAP
#pragma shader_feature_local _ANISOTROPYMAP
#pragma shader_feature_local _DETAIL_MAP
#pragma shader_feature_local _SUBSURFACE_MASK_MAP
#pragma shader_feature_local _THICKNESSMAP
#pragma shader_feature_local _IRIDESCENCE_THICKNESSMAP
#pragma shader_feature_local _SPECULARCOLORMAP
#pragma shader_feature_local _TRANSMITTANCECOLORMAP

#pragma shader_feature_local _DISABLE_DECALS
#pragma shader_feature_local _DISABLE_SSR
#pragma shader_feature_local _ENABLE_GEOMETRIC_SPECULAR_AA

// Keyword for transparent
#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
#pragma shader_feature_local _BLENDMODE_PRESERVE_SPECULAR_LIGHTING
#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
#pragma shader_feature_local _TRANSPARENT_WRITES_MOTION_VEC

// MaterialFeature are used as shader feature to allow compiler to optimize properly
#pragma shader_feature_local _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
#pragma shader_feature_local _MATERIAL_FEATURE_TRANSMISSION
#pragma shader_feature_local _MATERIAL_FEATURE_ANISOTROPY
#pragma shader_feature_local _MATERIAL_FEATURE_CLEAR_COAT
#pragma shader_feature_local _MATERIAL_FEATURE_IRIDESCENCE
#pragma shader_feature_local _MATERIAL_FEATURE_SPECULAR_COLOR

#pragma shader_feature_local _ADD_PRECOMPUTED_VELOCITY

// enable dithering LOD crossfade
#pragma multi_compile _ LOD_FADE_CROSSFADE

//enable GPU instancing support
#pragma multi_compile_instancing
#pragma instancing_options renderinglayer

//-------------------------------------------------------------------------------------
// Define
//-------------------------------------------------------------------------------------

// This shader support vertex modification
#define HAVE_VERTEX_MODIFICATION

// If we use subsurface scattering, enable output split lighting (for forward pass)
#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
#define OUTPUT_SPLIT_LIGHTING
#endif

#if defined(_TRANSPARENT_WRITES_MOTION_VEC) && defined(_SURFACE_TYPE_TRANSPARENT)
#define _WRITE_TRANSPARENT_MOTION_VECTOR
#endif
//-------------------------------------------------------------------------------------
// Include
//-------------------------------------------------------------------------------------

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

//-------------------------------------------------------------------------------------
// variable declaration
//-------------------------------------------------------------------------------------

// #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.cs.hlsl"
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitProperties.hlsl"

// TODO:
// Currently, Lit.hlsl and LitData.hlsl are included for every pass. Split Lit.hlsl in two:
// LitData.hlsl and LitShading.hlsl (merge into the existing LitData.hlsl).
// LitData.hlsl should be responsible for preparing shading parameters.
// LitShading.hlsl implements the light loop API.
// LitData.hlsl is included here, LitShading.hlsl is included below for shading passes only.

ENDHLSL

SubShader
    {
        // This tags allow to use the shader replacement features
        Tags{ "RenderPipeline" = "HDRenderPipeline" "RenderType" = "HDLitShader" }

        Pass
        {
            Name "SceneSelectionPass"
            Tags { "LightMode" = "SceneSelectionPass" }

            Cull Off

            HLSLPROGRAM

        // Note: Require _ObjectId and _PassValue variables

        // We reuse depth prepass for the scene selection, allow to handle alpha correctly as well as tessellation and vertex animation
        #define SHADERPASS SHADERPASS_DEPTH_ONLY
        #define SCENESELECTIONPASS // This will drive the output of the scene selection shader
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitDepthPass.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #if (SHADERPASS != SHADERPASS_DEPTH_ONLY && SHADERPASS != SHADERPASS_SHADOWS)
#error SHADERPASS_is_not_correctly_define
#endif

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);
    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    return PackVaryingsToPS(output);
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"

#endif // TESSELLATION_ON

void Frag(PackedVaryingsToPS packedInput
            #ifdef WRITE_NORMAL_BUFFER
            , out float4 outNormalBuffer : SV_Target0
                #ifdef WRITE_MSAA_DEPTH
                , out float1 depthColor : SV_Target1
                #endif
            #elif defined(WRITE_MSAA_DEPTH) // When only WRITE_MSAA_DEPTH is define and not WRITE_NORMAL_BUFFER it mean we are Unlit and only need depth, but we still have normal buffer binded
            , out float4 outNormalBuffer : SV_Target0
            , out float1 depthColor : SV_Target1
            #elif defined(SCENESELECTIONPASS)
            , out float4 outColor : SV_Target0
            #endif

            #ifdef _DEPTHOFFSET_ON
            , out float outputDepth : SV_Depth
            #endif
        )
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);



    // DARK_VISION
    if (length(input.positionRWS) >= DARK_VISION_CUT_LENGTH)
    {
    #ifdef WRITE_NORMAL_BUFFER
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
    #ifdef WRITE_MSAA_DEPTH
        depthColor = float1(0.0f);
    #endif
    #elif defined(WRITE_MSAA_DEPTH)
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
        depthColor = float1(0.0f);
    #elif defined(SCENESELECTIONPASS)
        outColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
    #endif
    #ifdef _DEPTHOFFSET_ON
        outputDepth = 0.0f;
    #endif
        return;
    }


    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

#ifdef _DEPTHOFFSET_ON
    outputDepth = posInput.deviceDepth;
#endif

#ifdef WRITE_NORMAL_BUFFER
    EncodeIntoNormalBuffer(ConvertSurfaceDataToNormalData(surfaceData), posInput.positionSS, outNormalBuffer);
    #ifdef WRITE_MSAA_DEPTH
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
    #endif
#elif defined(WRITE_MSAA_DEPTH) // When we are MSAA depth only without normal buffer
    // Due to the binding order of these two render targets, we need to have them both declared
    outNormalBuffer = float4(0.0, 0.0, 0.0, 1.0);
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
#elif defined(SCENESELECTIONPASS)
    // We use depth prepass for scene selection in the editor, this code allow to output the outline correctly
    outColor = float4(_ObjectId, _PassValue, 1.0, 1.0);
#endif
}


        #pragma vertex Vert
        #pragma fragment Frag

        #pragma editor_sync_compilation

        ENDHLSL
    }

        // Caution: The outline selection in the editor use the vertex shader/hull/domain shader of the first pass declare. So it should not bethe  meta pass.
        Pass
        {
            Name "GBuffer"
            Tags { "LightMode" = "GBuffer" } // This will be only for opaque object based on the RenderQueue index

            Cull[_CullMode]
            ZTest[_ZTestGBuffer]

            Stencil
            {
                WriteMask[_StencilWriteMaskGBuffer]
                Ref[_StencilRefGBuffer]
                Comp Always
                Pass Replace
            }

            HLSLPROGRAM

            #pragma multi_compile _ DEBUG_DISPLAY
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile _ SHADOWS_SHADOWMASK
        // Setup DECALS_OFF so the shader stripper can remove variants
        #pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
        #pragma multi_compile _ LIGHT_LAYERS

    #ifndef DEBUG_DISPLAY
        // When we have alpha test, we will force a depth prepass so we always bypass the clip instruction in the GBuffer
        // Don't do it with debug display mode as it is possible there is no depth prepass in this case
        #define SHADERPASS_GBUFFER_BYPASS_ALPHA_TEST
    #endif

        #define SHADERPASS SHADERPASS_GBUFFER
        #ifdef DEBUG_DISPLAY
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitSharePass.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"

        #if SHADERPASS != SHADERPASS_GBUFFER
#error SHADERPASS_is_not_correctly_define
#endif

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);
    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    return PackVaryingsToPS(output);
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"

#endif // TESSELLATION_ON

void Frag(PackedVaryingsToPS packedInput,
            OUTPUT_GBUFFER(outGBuffer)
            #ifdef _DEPTHOFFSET_ON
            , out float outputDepth : SV_Depth
            #endif
            )
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);

    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

    ENCODE_INTO_GBUFFER(surfaceData, builtinData, posInput.positionSS, outGBuffer);

#ifdef _DEPTHOFFSET_ON
    outputDepth = posInput.deviceDepth;
#endif
    float3 pos = input.positionRWS;
    pos.y += 2.0f;
    if (length(pos) >= DARK_VISION_CUT_LENGTH)
    {
        outGBuffer0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
        outGBuffer1.arg = float3(0.0f, 0.0f, 0.0f);
        outGBuffer2 = float4(0.0f, 0.0f, 0.0f, 1.0f);
        outGBuffer3 = float4(0.0f, 0.0f, 0.0f, 1.0f);
    }
}

        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }

        // Extracts information for lightmapping, GI (emission, albedo, ...)
        // This pass it not used during regular rendering.
        Pass
        {
            Name "META"
            Tags{ "LightMode" = "META" }

            Cull Off

            HLSLPROGRAM

        // Lightmap memo
        // DYNAMICLIGHTMAP_ON is used when we have an "enlighten lightmap" ie a lightmap updated at runtime by enlighten.This lightmap contain indirect lighting from realtime lights and realtime emissive material.Offline baked lighting(from baked material / light,
        // both direct and indirect lighting) will hand up in the "regular" lightmap->LIGHTMAP_ON.

        #define SHADERPASS SHADERPASS_LIGHT_TRANSPORT
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitSharePass.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #if SHADERPASS != SHADERPASS_LIGHT_TRANSPORT
#error SHADERPASS_is_not_correctly_define
#endif

CBUFFER_START(UnityMetaPass)
// x = use uv1 as raster position
// y = use uv2 as raster position
bool4 unity_MetaVertexControl;

        // x = return albedo
        // y = return normal
        bool4 unity_MetaFragmentControl;
        CBUFFER_END


            // This was not in constant buffer in original unity, so keep outiside. But should be in as ShaderRenderPass frequency
            float unity_OneOverOutputBoost;
            float unity_MaxOutputValue;

            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

            PackedVaryingsToPS Vert(AttributesMesh inputMesh)
            {
                VaryingsToPS output;

                UNITY_SETUP_INSTANCE_ID(inputMesh);
                UNITY_TRANSFER_INSTANCE_ID(inputMesh, output.vmesh);

                // Output UV coordinate in vertex shader
                float2 uv = float2(0.0, 0.0);

                if (unity_MetaVertexControl.x)
                {
                    uv = inputMesh.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                }
                else if (unity_MetaVertexControl.y)
                {
                    uv = inputMesh.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                }

                // OpenGL right now needs to actually use the incoming vertex position
                // so we create a fake dependency on it here that haven't any impact.
                output.vmesh.positionCS = float4(uv * 2.0 - 1.0, inputMesh.positionOS.z > 0 ? 1.0e-4 : 0.0, 1.0);

            #ifdef VARYINGS_NEED_POSITION_WS
                output.vmesh.positionRWS = TransformObjectToWorld(inputMesh.positionOS);
            #endif

            #ifdef VARYINGS_NEED_TANGENT_TO_WORLD
                // Normal is required for triplanar mapping
                output.vmesh.normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
                // Not required but assign to silent compiler warning
                output.vmesh.tangentWS = float4(1.0, 0.0, 0.0, 0.0);
            #endif

            #ifdef VARYINGS_NEED_TEXCOORD0
                output.vmesh.texCoord0 = inputMesh.uv0;
            #endif
            #ifdef VARYINGS_NEED_TEXCOORD1
                output.vmesh.texCoord1 = inputMesh.uv1;
            #endif
            #ifdef VARYINGS_NEED_TEXCOORD2
                output.vmesh.texCoord2 = inputMesh.uv2;
            #endif
            #ifdef VARYINGS_NEED_TEXCOORD3
                output.vmesh.texCoord3 = inputMesh.uv3;
            #endif
            #ifdef VARYINGS_NEED_COLOR
                output.vmesh.color = inputMesh.color;
            #endif

                return PackVaryingsToPS(output);
            }

            float4 Frag(PackedVaryingsToPS packedInput) : SV_Target
            {
                FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);


            // DARK_VISION
            if (length(input.positionRWS) >= DARK_VISION_CUT_LENGTH)
                return float4(0.0f, 0.0f, 0.0f, 1.0f);


            // input.positionSS is SV_Position
            PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

        #ifdef VARYINGS_NEED_POSITION_WS
            float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
        #else
            // Unused
            float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
        #endif

            SurfaceData surfaceData;
            BuiltinData builtinData;
            GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

            // no debug apply during light transport pass

            BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);
            LightTransportData lightTransportData = GetLightTransportData(surfaceData, builtinData, bsdfData);

            // This shader is call two times. Once for getting emissiveColor, the other time to get diffuseColor
            // We use unity_MetaFragmentControl to make the distinction.
            float4 res = float4(0.0, 0.0, 0.0, 1.0);

            if (unity_MetaFragmentControl.x)
            {
                // Apply diffuseColor Boost from LightmapSettings.
                // put abs here to silent a warning, no cost, no impact as color is assume to be positive.
                res.rgb = clamp(pow(abs(lightTransportData.diffuseColor), saturate(unity_OneOverOutputBoost)), 0, unity_MaxOutputValue);
            }

            if (unity_MetaFragmentControl.y)
            {
                // emissive use HDR format
                res.rgb = lightTransportData.emissiveColor;
            }

            return res;
        }


        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }

    Pass
    {
        Name "ShadowCaster"
        Tags{ "LightMode" = "ShadowCaster" }

        Cull[_CullMode]

        ZClip[_ZClip]
        ZWrite On
        ZTest LEqual

        ColorMask 0

        HLSLPROGRAM

        #define SHADERPASS SHADERPASS_SHADOWS
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitDepthPass.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #if (SHADERPASS != SHADERPASS_DEPTH_ONLY && SHADERPASS != SHADERPASS_SHADOWS)
#error SHADERPASS_is_not_correctly_define
#endif

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);
    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    return PackVaryingsToPS(output);
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"

#endif // TESSELLATION_ON

void Frag(PackedVaryingsToPS packedInput
            #ifdef WRITE_NORMAL_BUFFER
            , out float4 outNormalBuffer : SV_Target0
                #ifdef WRITE_MSAA_DEPTH
                , out float1 depthColor : SV_Target1
                #endif
            #elif defined(WRITE_MSAA_DEPTH) // When only WRITE_MSAA_DEPTH is define and not WRITE_NORMAL_BUFFER it mean we are Unlit and only need depth, but we still have normal buffer binded
            , out float4 outNormalBuffer : SV_Target0
            , out float1 depthColor : SV_Target1
            #elif defined(SCENESELECTIONPASS)
            , out float4 outColor : SV_Target0
            #endif

            #ifdef _DEPTHOFFSET_ON
            , out float outputDepth : SV_Depth
            #endif
        )
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);

    // DARK_VISION
    if (length(input.positionRWS) >= DARK_VISION_CUT_LENGTH)
    {
#ifdef WRITE_NORMAL_BUFFER
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
#ifdef WRITE_MSAA_DEPTH
        depthColor = float1(0.0f);
#endif
#elif defined(WRITE_MSAA_DEPTH)
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
        depthColor = float1(0.0f);
#elif defined(SCENESELECTIONPASS)
        outColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
#endif
#ifdef _DEPTHOFFSET_ON
        outputDepth = 0.0f;
#endif
        return;
    }

    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

#ifdef _DEPTHOFFSET_ON
    outputDepth = posInput.deviceDepth;
#endif

#ifdef WRITE_NORMAL_BUFFER
    EncodeIntoNormalBuffer(ConvertSurfaceDataToNormalData(surfaceData), posInput.positionSS, outNormalBuffer);
    #ifdef WRITE_MSAA_DEPTH
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
    #endif
#elif defined(WRITE_MSAA_DEPTH) // When we are MSAA depth only without normal buffer
    // Due to the binding order of these two render targets, we need to have them both declared
    outNormalBuffer = float4(0.0, 0.0, 0.0, 1.0);
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
#elif defined(SCENESELECTIONPASS)
    // We use depth prepass for scene selection in the editor, this code allow to output the outline correctly
    outColor = float4(_ObjectId, _PassValue, 1.0, 1.0);
#endif
}


        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }

    Pass
    {
        Name "DepthOnly"
        Tags{ "LightMode" = "DepthOnly" }

        Cull[_CullMode]

        // To be able to tag stencil with disableSSR information for forward
        Stencil
        {
            WriteMask[_StencilWriteMaskDepth]
            Ref[_StencilRefDepth]
            Comp Always
            Pass Replace
        }

        ZWrite On

        HLSLPROGRAM

        // In deferred, depth only pass don't output anything.
        // In forward it output the normal buffer
        #pragma multi_compile _ WRITE_NORMAL_BUFFER
        #pragma multi_compile _ WRITE_MSAA_DEPTH

        #define SHADERPASS SHADERPASS_DEPTH_ONLY
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"

        #ifdef WRITE_NORMAL_BUFFER // If enabled we need all regular interpolator
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitSharePass.hlsl"
        #else
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitDepthPass.hlsl"
        #endif

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #if (SHADERPASS != SHADERPASS_DEPTH_ONLY && SHADERPASS != SHADERPASS_SHADOWS)
#error SHADERPASS_is_not_correctly_define
#endif

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);
    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    return PackVaryingsToPS(output);
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"

#endif // TESSELLATION_ON

void Frag(PackedVaryingsToPS packedInput
            #ifdef WRITE_NORMAL_BUFFER
            , out float4 outNormalBuffer : SV_Target0
                #ifdef WRITE_MSAA_DEPTH
                , out float1 depthColor : SV_Target1
                #endif
            #elif defined(WRITE_MSAA_DEPTH) // When only WRITE_MSAA_DEPTH is define and not WRITE_NORMAL_BUFFER it mean we are Unlit and only need depth, but we still have normal buffer binded
            , out float4 outNormalBuffer : SV_Target0
            , out float1 depthColor : SV_Target1
            #elif defined(SCENESELECTIONPASS)
            , out float4 outColor : SV_Target0
            #endif

            #ifdef _DEPTHOFFSET_ON
            , out float outputDepth : SV_Depth
            #endif
        )
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);

    // DARK_VISION
    if (length(input.positionRWS) >= DARK_VISION_CUT_LENGTH)
    {
#ifdef WRITE_NORMAL_BUFFER
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
#ifdef WRITE_MSAA_DEPTH
        depthColor = float1(0.0f);
#endif
#elif defined(WRITE_MSAA_DEPTH)
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
        depthColor = float1(0.0f);
#elif defined(SCENESELECTIONPASS)
        outColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
#endif
#ifdef _DEPTHOFFSET_ON
        outputDepth = 0.0f;
#endif
        return;
    }

    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

#ifdef _DEPTHOFFSET_ON
    outputDepth = posInput.deviceDepth;
#endif

#ifdef WRITE_NORMAL_BUFFER
    EncodeIntoNormalBuffer(ConvertSurfaceDataToNormalData(surfaceData), posInput.positionSS, outNormalBuffer);
    #ifdef WRITE_MSAA_DEPTH
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
    #endif
#elif defined(WRITE_MSAA_DEPTH) // When we are MSAA depth only without normal buffer
    // Due to the binding order of these two render targets, we need to have them both declared
    outNormalBuffer = float4(0.0, 0.0, 0.0, 1.0);
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
#elif defined(SCENESELECTIONPASS)
    // We use depth prepass for scene selection in the editor, this code allow to output the outline correctly
    outColor = float4(_ObjectId, _PassValue, 1.0, 1.0);
#endif
}


        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }

    Pass
    {
        Name "MotionVectors"
        Tags{ "LightMode" = "MotionVectors" } // Caution, this need to be call like this to setup the correct parameters by C++ (legacy Unity)

        // If velocity pass (motion vectors) is enabled we tag the stencil so it don't perform CameraMotionVelocity
        Stencil
        {
            WriteMask[_StencilWriteMaskMV]
            Ref[_StencilRefMV]
            Comp Always
            Pass Replace
        }

        Cull[_CullMode]

        ZWrite On

        HLSLPROGRAM
        #pragma multi_compile _ WRITE_NORMAL_BUFFER
        #pragma multi_compile _ WRITE_MSAA_DEPTH

        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #ifdef WRITE_NORMAL_BUFFER // If enabled we need all regular interpolator
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitSharePass.hlsl"
        #else
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitMotionVectorPass.hlsl"
        #endif
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassMotionVectors.hlsl"

        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }

    Pass
    {
        Name "DistortionVectors"
        Tags { "LightMode" = "DistortionVectors" } // This will be only for transparent object based on the RenderQueue index

        Stencil
        {
            WriteMask[_StencilRefDistortionVec]
            Ref[_StencilRefDistortionVec]
            Comp Always
            Pass Replace
        }

        Blend[_DistortionSrcBlend][_DistortionDstBlend],[_DistortionBlurSrcBlend][_DistortionBlurDstBlend]
        BlendOp Add,[_DistortionBlurBlendOp]
        ZTest[_ZTestModeDistortion]
        ZWrite off
        Cull[_CullMode]

        HLSLPROGRAM

        #define SHADERPASS SHADERPASS_DISTORTION
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitDistortionPass.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #if SHADERPASS != SHADERPASS_DISTORTION
#error SHADERPASS_is_not_correctly_define
#endif

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);
    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    return PackVaryingsToPS(output);
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"

#endif // TESSELLATION_ON

float4 Frag(PackedVaryingsToPS packedInput) : SV_Target
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);


    // DARK_VISION
    if (length(input.positionRWS) >= DARK_VISION_CUT_LENGTH)
        return float4(0.0f, 0.0f, 0.0f, 1.0f);


    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    // Perform alpha testing + get distortion
    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

    float4 outBuffer;
    // Mark this pixel as eligible as source for distortion
    EncodeDistortion(builtinData.distortion, builtinData.distortionBlur, true, outBuffer);
    return outBuffer;
}


        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }

    Pass
    {
        Name "TransparentDepthPrepass"
        Tags{ "LightMode" = "TransparentDepthPrepass" }

        Cull[_CullMode]
        ZWrite On
        ColorMask 0

        HLSLPROGRAM

        #define SHADERPASS SHADERPASS_DEPTH_ONLY
        #define CUTOFF_TRANSPARENT_DEPTH_PREPASS
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitDepthPass.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #if (SHADERPASS != SHADERPASS_DEPTH_ONLY && SHADERPASS != SHADERPASS_SHADOWS)
#error SHADERPASS_is_not_correctly_define
#endif

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);
    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    return PackVaryingsToPS(output);
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"

#endif // TESSELLATION_ON

void Frag(PackedVaryingsToPS packedInput
            #ifdef WRITE_NORMAL_BUFFER
            , out float4 outNormalBuffer : SV_Target0
                #ifdef WRITE_MSAA_DEPTH
                , out float1 depthColor : SV_Target1
                #endif
            #elif defined(WRITE_MSAA_DEPTH) // When only WRITE_MSAA_DEPTH is define and not WRITE_NORMAL_BUFFER it mean we are Unlit and only need depth, but we still have normal buffer binded
            , out float4 outNormalBuffer : SV_Target0
            , out float1 depthColor : SV_Target1
            #elif defined(SCENESELECTIONPASS)
            , out float4 outColor : SV_Target0
            #endif

            #ifdef _DEPTHOFFSET_ON
            , out float outputDepth : SV_Depth
            #endif
        )
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);


    // DARK_VISION
    if (length(input.positionRWS) >= DARK_VISION_CUT_LENGTH)
    {
#ifdef WRITE_NORMAL_BUFFER
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
#ifdef WRITE_MSAA_DEPTH
        depthColor = float1(0.0f);
#endif
#elif defined(WRITE_MSAA_DEPTH)
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
        depthColor = float1(0.0f);
#elif defined(SCENESELECTIONPASS)
        outColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
#endif
#ifdef _DEPTHOFFSET_ON
        outputDepth = 0.0f;
#endif
        return;
    }


    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

#ifdef _DEPTHOFFSET_ON
    outputDepth = posInput.deviceDepth;
#endif

#ifdef WRITE_NORMAL_BUFFER
    EncodeIntoNormalBuffer(ConvertSurfaceDataToNormalData(surfaceData), posInput.positionSS, outNormalBuffer);
    #ifdef WRITE_MSAA_DEPTH
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
    #endif
#elif defined(WRITE_MSAA_DEPTH) // When we are MSAA depth only without normal buffer
    // Due to the binding order of these two render targets, we need to have them both declared
    outNormalBuffer = float4(0.0, 0.0, 0.0, 1.0);
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
#elif defined(SCENESELECTIONPASS)
    // We use depth prepass for scene selection in the editor, this code allow to output the outline correctly
    outColor = float4(_ObjectId, _PassValue, 1.0, 1.0);
#endif
}


        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }

        // Caution: Order is important: TransparentBackface, then Forward/ForwardOnly
        Pass
        {
            Name "TransparentBackface"
            Tags { "LightMode" = "TransparentBackface" }

            Blend[_SrcBlend][_DstBlend],[_AlphaSrcBlend][_AlphaDstBlend]
            ZWrite[_ZWrite]
            Cull Front
            ColorMask[_ColorMaskTransparentVel] 1
            ZTest[_ZTestTransparent]

            HLSLPROGRAM

            #pragma multi_compile _ DEBUG_DISPLAY
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile _ SHADOWS_SHADOWMASK
        // Setup DECALS_OFF so the shader stripper can remove variants
        #pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT

        // Supported shadow modes per light type
        #pragma multi_compile SHADOW_LOW SHADOW_MEDIUM SHADOW_HIGH

        #define USE_CLUSTERED_LIGHTLIST // There is not FPTL lighting when using transparent

        #define SHADERPASS SHADERPASS_FORWARD
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

    #ifdef DEBUG_DISPLAY
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
    #endif

        // The light loop (or lighting architecture) is in charge to:
        // - Define light list
        // - Define the light loop
        // - Setup the constant/data
        // - Do the reflection hierarchy
        // - Provide sampling function for shadowmap, ies, cookie and reflection (depends on the specific use with the light loops like index array or atlas or single and texture format (cubemap/latlong))

        #define HAS_LIGHTLOOP

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitSharePass.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #if SHADERPASS != SHADERPASS_FORWARD
#error SHADERPASS_is_not_correctly_define
#endif

#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/MotionVectorVertexShaderCommon.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh, AttributesPass inputPass)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);
    return MotionVectorVS(varyingsType, inputMesh, inputPass);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    MotionVectorPositionZBias(output);

    output.vpass.positionCS = input.vpass.positionCS;
    output.vpass.previousPositionCS = input.vpass.previousPositionCS;

    return PackVaryingsToPS(output);
}

#endif // TESSELLATION_ON

#else // _WRITE_TRANSPARENT_MOTION_VECTOR

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);

    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);

    return PackVaryingsToPS(output);
}


#endif // TESSELLATION_ON

#endif // _WRITE_TRANSPARENT_MOTION_VECTOR


#ifdef TESSELLATION_ON
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"
#endif

void Frag(PackedVaryingsToPS packedInput,
#ifdef OUTPUT_SPLIT_LIGHTING
    out float4 outColor : SV_Target0,  // outSpecularLighting
    out float4 outDiffuseLighting : SV_Target1,
    OUTPUT_SSSBUFFER(outSSSBuffer)
#else
    out float4 outColor : SV_Target0
#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
    , out float4 outMotionVec : SV_Target1
#endif // _WRITE_TRANSPARENT_MOTION_VECTOR
#endif // OUTPUT_SPLIT_LIGHTING
#ifdef _DEPTHOFFSET_ON
    , out float outputDepth : SV_Depth
#endif
)
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);


    // DARK_VISION
    if (length(input.positionRWS) >= DARK_VISION_CUT_LENGTH)
    {
#ifdef OUTPUT_SPLIT_LIGHTING
        outColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
        outDiffuseLighting = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
        outColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
        outMotionVec = float4(0.0f, 0.0f, 0.0f, 1.0f);
#endif
#endif
#ifdef _DEPTHOFFSET_ON
        outputDepth = 0.0f;
#endif
        return;
    }


    // We need to readapt the SS position as our screen space positions are for a low res buffer, but we try to access a full res buffer.
    input.positionSS.xy = _OffScreenRendering > 0 ? (input.positionSS.xy * _OffScreenDownsampleFactor) : input.positionSS.xy;

    uint2 tileIndex = uint2(input.positionSS.xy) / GetTileSize();

    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS.xyz, tileIndex);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

    BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);

    PreLightData preLightData = GetPreLightData(V, posInput, bsdfData);

    outColor = float4(0.0, 0.0, 0.0, 0.0);

    // We need to skip lighting when doing debug pass because the debug pass is done before lighting so some buffers may not be properly initialized potentially causing crashes on PS4.

#ifdef DEBUG_DISPLAY
    // Init in debug display mode to quiet warning
#ifdef OUTPUT_SPLIT_LIGHTING
    outDiffuseLighting = 0;
    ENCODE_INTO_SSSBUFFER(surfaceData, posInput.positionSS, outSSSBuffer);
#endif



    // Same code in ShaderPassForwardUnlit.shader
    // Reminder: _DebugViewMaterialArray[i]
    //   i==0 -> the size used in the buffer
    //   i>0  -> the index used (0 value means nothing)
    // The index stored in this buffer could either be
    //   - a gBufferIndex (always stored in _DebugViewMaterialArray[1] as only one supported)
    //   - a property index which is different for each kind of material even if reflecting the same thing (see MaterialSharedProperty)
    bool viewMaterial = false;
    int bufferSize = int(_DebugViewMaterialArray[0]);
    if (bufferSize != 0)
    {
        bool needLinearToSRGB = false;
        float3 result = float3(1.0, 0.0, 1.0);

        // Loop through the whole buffer
        // Works because GetSurfaceDataDebug will do nothing if the index is not a known one
        for (int index = 1; index <= bufferSize; index++)
        {
            int indexMaterialProperty = int(_DebugViewMaterialArray[index]);

            // skip if not really in use
            if (indexMaterialProperty != 0)
            {
                viewMaterial = true;

                GetPropertiesDataDebug(indexMaterialProperty, result, needLinearToSRGB);
                GetVaryingsDataDebug(indexMaterialProperty, input, result, needLinearToSRGB);
                GetBuiltinDataDebug(indexMaterialProperty, builtinData, result, needLinearToSRGB);
                GetSurfaceDataDebug(indexMaterialProperty, surfaceData, result, needLinearToSRGB);
                GetBSDFDataDebug(indexMaterialProperty, bsdfData, result, needLinearToSRGB);
            }
        }

        // TEMP!
        // For now, the final blit in the backbuffer performs an sRGB write
        // So in the meantime we apply the inverse transform to linear data to compensate.
        if (!needLinearToSRGB)
            result = SRGBToLinear(max(0, result));

        outColor = float4(result, 1.0);
    }

    if (!viewMaterial)
    {
        if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_DIFFUSE_COLOR || _DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_SPECULAR_COLOR)
        {
            float3 result = float3(0.0, 0.0, 0.0);

            GetPBRValidatorDebug(surfaceData, result);

            outColor = float4(result, 1.0f);
        }
        else if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_TRANSPARENCY_OVERDRAW)
        {
            float4 result = _DebugTransparencyOverdrawWeight * float4(TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_A);
            outColor = result;
        }
        else
#endif
        {
#ifdef _SURFACE_TYPE_TRANSPARENT
            uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_TRANSPARENT;
#else
            uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_OPAQUE;
#endif
            float3 diffuseLighting;
            float3 specularLighting;

            LightLoop(V, posInput, preLightData, bsdfData, builtinData, featureFlags, diffuseLighting, specularLighting);

            diffuseLighting *= GetCurrentExposureMultiplier();
            specularLighting *= GetCurrentExposureMultiplier();

#ifdef OUTPUT_SPLIT_LIGHTING
            if (_EnableSubsurfaceScattering != 0 && ShouldOutputSplitLighting(bsdfData))
            {
                outColor = float4(specularLighting, 1.0);
                outDiffuseLighting = float4(TagLightingForSSS(diffuseLighting), 1.0);
            }
            else
            {
                outColor = float4(diffuseLighting + specularLighting, 1.0);
                outDiffuseLighting = 0;
            }
            ENCODE_INTO_SSSBUFFER(surfaceData, posInput.positionSS, outSSSBuffer);
#else
            outColor = ApplyBlendMode(diffuseLighting, specularLighting, builtinData.opacity);
            outColor = EvaluateAtmosphericScattering(posInput, V, outColor);
#endif

#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
            VaryingsPassToPS inputPass = UnpackVaryingsPassToPS(packedInput.vpass);
            bool forceNoMotion = any(unity_MotionVectorsParams.yw == 0.0);
            if (forceNoMotion)
            {
                outMotionVec = float4(2.0, 0.0, 0.0, 0.0);
            }
            else
            {
                float2 motionVec = CalculateMotionVector(inputPass.positionCS, inputPass.previousPositionCS);
                EncodeMotionVector(motionVec * 0.5, outMotionVec);
                outMotionVec.zw = 1.0;
            }
#endif
        }

#ifdef DEBUG_DISPLAY
    }
#endif

#ifdef _DEPTHOFFSET_ON
    outputDepth = posInput.deviceDepth;
#endif
}


        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }

    Pass
    {
        Name "Forward"
        Tags { "LightMode" = "Forward" } // This will be only for transparent object based on the RenderQueue index

        Stencil
        {
            WriteMask[_StencilWriteMask]
            Ref[_StencilRef]
            Comp Always
            Pass Replace
        }

        Blend[_SrcBlend][_DstBlend],[_AlphaSrcBlend][_AlphaDstBlend]
        // In case of forward we want to have depth equal for opaque mesh
        ZTest[_ZTestDepthEqualForOpaque]
        ZWrite[_ZWrite]
        Cull[_CullModeForward]
        ColorMask[_ColorMaskTransparentVel] 1

        HLSLPROGRAM

        #pragma multi_compile _ DEBUG_DISPLAY
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        // Setup DECALS_OFF so the shader stripper can remove variants
        #pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT

        // Supported shadow modes per light type
        #pragma multi_compile SHADOW_LOW SHADOW_MEDIUM SHADOW_HIGH

        #pragma multi_compile USE_FPTL_LIGHTLIST USE_CLUSTERED_LIGHTLIST

        #define SHADERPASS SHADERPASS_FORWARD
        // In case of opaque we don't want to perform the alpha test, it is done in depth prepass and we use depth equal for ztest (setup from UI)
        // Don't do it with debug display mode as it is possible there is no depth prepass in this case
        #if !defined(_SURFACE_TYPE_TRANSPARENT) && !defined(DEBUG_DISPLAY)
            #define SHADERPASS_FORWARD_BYPASS_ALPHA_TEST
        #endif
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

    #ifdef DEBUG_DISPLAY
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
    #endif

        // The light loop (or lighting architecture) is in charge to:
        // - Define light list
        // - Define the light loop
        // - Setup the constant/data
        // - Do the reflection hierarchy
        // - Provide sampling function for shadowmap, ies, cookie and reflection (depends on the specific use with the light loops like index array or atlas or single and texture format (cubemap/latlong))

        #define HAS_LIGHTLOOP

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitSharePass.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #if SHADERPASS != SHADERPASS_FORWARD
#error SHADERPASS_is_not_correctly_define
#endif

#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/MotionVectorVertexShaderCommon.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh, AttributesPass inputPass)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);
    return MotionVectorVS(varyingsType, inputMesh, inputPass);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    MotionVectorPositionZBias(output);

    output.vpass.positionCS = input.vpass.positionCS;
    output.vpass.previousPositionCS = input.vpass.previousPositionCS;

    return PackVaryingsToPS(output);
}

#endif // TESSELLATION_ON

#else // _WRITE_TRANSPARENT_MOTION_VECTOR

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);

    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);

    return PackVaryingsToPS(output);
}


#endif // TESSELLATION_ON

#endif // _WRITE_TRANSPARENT_MOTION_VECTOR


#ifdef TESSELLATION_ON
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"
#endif

void Frag(PackedVaryingsToPS packedInput,
#ifdef OUTPUT_SPLIT_LIGHTING
    out float4 outColor : SV_Target0,  // outSpecularLighting
    out float4 outDiffuseLighting : SV_Target1,
    OUTPUT_SSSBUFFER(outSSSBuffer)
#else
    out float4 outColor : SV_Target0
#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
    , out float4 outMotionVec : SV_Target1
#endif // _WRITE_TRANSPARENT_MOTION_VECTOR
#endif // OUTPUT_SPLIT_LIGHTING
#ifdef _DEPTHOFFSET_ON
    , out float outputDepth : SV_Depth
#endif
)
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);

    // DARK_VISION
    if (length(input.positionRWS) >= DARK_VISION_CUT_LENGTH)
    {
#ifdef OUTPUT_SPLIT_LIGHTING
        outColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
        outDiffuseLighting = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
        outColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
        outMotionVec = float4(0.0f, 0.0f, 0.0f, 1.0f);
#endif
#endif
#ifdef _DEPTHOFFSET_ON
        outputDepth = 0.0f;
#endif
        return;
    }

    // We need to readapt the SS position as our screen space positions are for a low res buffer, but we try to access a full res buffer.
    input.positionSS.xy = _OffScreenRendering > 0 ? (input.positionSS.xy * _OffScreenDownsampleFactor) : input.positionSS.xy;

    uint2 tileIndex = uint2(input.positionSS.xy) / GetTileSize();

    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS.xyz, tileIndex);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

    BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);

    PreLightData preLightData = GetPreLightData(V, posInput, bsdfData);

    outColor = float4(0.0, 0.0, 0.0, 0.0);

    // We need to skip lighting when doing debug pass because the debug pass is done before lighting so some buffers may not be properly initialized potentially causing crashes on PS4.

#ifdef DEBUG_DISPLAY
    // Init in debug display mode to quiet warning
#ifdef OUTPUT_SPLIT_LIGHTING
    outDiffuseLighting = 0;
    ENCODE_INTO_SSSBUFFER(surfaceData, posInput.positionSS, outSSSBuffer);
#endif



    // Same code in ShaderPassForwardUnlit.shader
    // Reminder: _DebugViewMaterialArray[i]
    //   i==0 -> the size used in the buffer
    //   i>0  -> the index used (0 value means nothing)
    // The index stored in this buffer could either be
    //   - a gBufferIndex (always stored in _DebugViewMaterialArray[1] as only one supported)
    //   - a property index which is different for each kind of material even if reflecting the same thing (see MaterialSharedProperty)
    bool viewMaterial = false;
    int bufferSize = int(_DebugViewMaterialArray[0]);
    if (bufferSize != 0)
    {
        bool needLinearToSRGB = false;
        float3 result = float3(1.0, 0.0, 1.0);

        // Loop through the whole buffer
        // Works because GetSurfaceDataDebug will do nothing if the index is not a known one
        for (int index = 1; index <= bufferSize; index++)
        {
            int indexMaterialProperty = int(_DebugViewMaterialArray[index]);

            // skip if not really in use
            if (indexMaterialProperty != 0)
            {
                viewMaterial = true;

                GetPropertiesDataDebug(indexMaterialProperty, result, needLinearToSRGB);
                GetVaryingsDataDebug(indexMaterialProperty, input, result, needLinearToSRGB);
                GetBuiltinDataDebug(indexMaterialProperty, builtinData, result, needLinearToSRGB);
                GetSurfaceDataDebug(indexMaterialProperty, surfaceData, result, needLinearToSRGB);
                GetBSDFDataDebug(indexMaterialProperty, bsdfData, result, needLinearToSRGB);
            }
        }

        // TEMP!
        // For now, the final blit in the backbuffer performs an sRGB write
        // So in the meantime we apply the inverse transform to linear data to compensate.
        if (!needLinearToSRGB)
            result = SRGBToLinear(max(0, result));

        outColor = float4(result, 1.0);
    }

    if (!viewMaterial)
    {
        if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_DIFFUSE_COLOR || _DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_SPECULAR_COLOR)
        {
            float3 result = float3(0.0, 0.0, 0.0);

            GetPBRValidatorDebug(surfaceData, result);

            outColor = float4(result, 1.0f);
        }
        else if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_TRANSPARENCY_OVERDRAW)
        {
            float4 result = _DebugTransparencyOverdrawWeight * float4(TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_A);
            outColor = result;
        }
        else
#endif
        {
#ifdef _SURFACE_TYPE_TRANSPARENT
            uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_TRANSPARENT;
#else
            uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_OPAQUE;
#endif
            float3 diffuseLighting;
            float3 specularLighting;

            LightLoop(V, posInput, preLightData, bsdfData, builtinData, featureFlags, diffuseLighting, specularLighting);

            diffuseLighting *= GetCurrentExposureMultiplier();
            specularLighting *= GetCurrentExposureMultiplier();

#ifdef OUTPUT_SPLIT_LIGHTING
            if (_EnableSubsurfaceScattering != 0 && ShouldOutputSplitLighting(bsdfData))
            {
                outColor = float4(specularLighting, 1.0);
                outDiffuseLighting = float4(TagLightingForSSS(diffuseLighting), 1.0);
            }
            else
            {
                outColor = float4(diffuseLighting + specularLighting, 1.0);
                outDiffuseLighting = 0;
            }
            ENCODE_INTO_SSSBUFFER(surfaceData, posInput.positionSS, outSSSBuffer);
#else
            outColor = ApplyBlendMode(diffuseLighting, specularLighting, builtinData.opacity);
            outColor = EvaluateAtmosphericScattering(posInput, V, outColor);
#endif

#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
            VaryingsPassToPS inputPass = UnpackVaryingsPassToPS(packedInput.vpass);
            bool forceNoMotion = any(unity_MotionVectorsParams.yw == 0.0);
            if (forceNoMotion)
            {
                outMotionVec = float4(2.0, 0.0, 0.0, 0.0);
            }
            else
            {
                float2 motionVec = CalculateMotionVector(inputPass.positionCS, inputPass.previousPositionCS);
                EncodeMotionVector(motionVec * 0.5, outMotionVec);
                outMotionVec.zw = 1.0;
            }
#endif
        }

#ifdef DEBUG_DISPLAY
    }
#endif

#ifdef _DEPTHOFFSET_ON
    outputDepth = posInput.deviceDepth;
#endif
}


        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }

    Pass
    {
        Name "TransparentDepthPostpass"
        Tags { "LightMode" = "TransparentDepthPostpass" }

        Cull[_CullMode]
        ZWrite On
        ColorMask 0

        HLSLPROGRAM
        #define SHADERPASS SHADERPASS_DEPTH_ONLY
        #define CUTOFF_TRANSPARENT_DEPTH_POSTPASS
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/ShaderPass/LitDepthPass.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitData.hlsl"
        #if (SHADERPASS != SHADERPASS_DEPTH_ONLY && SHADERPASS != SHADERPASS_SHADOWS)
#error SHADERPASS_is_not_correctly_define
#endif

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(AttributesMesh inputMesh)
{
    VaryingsType varyingsType;
    varyingsType.vmesh = VertMesh(inputMesh);
    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    return PackVaryingsToPS(output);
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"

#endif // TESSELLATION_ON

void Frag(PackedVaryingsToPS packedInput
            #ifdef WRITE_NORMAL_BUFFER
            , out float4 outNormalBuffer : SV_Target0
                #ifdef WRITE_MSAA_DEPTH
                , out float1 depthColor : SV_Target1
                #endif
            #elif defined(WRITE_MSAA_DEPTH) // When only WRITE_MSAA_DEPTH is define and not WRITE_NORMAL_BUFFER it mean we are Unlit and only need depth, but we still have normal buffer binded
            , out float4 outNormalBuffer : SV_Target0
            , out float1 depthColor : SV_Target1
            #elif defined(SCENESELECTIONPASS)
            , out float4 outColor : SV_Target0
            #endif

            #ifdef _DEPTHOFFSET_ON
            , out float outputDepth : SV_Depth
            #endif
        )
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsMeshToFragInputs(packedInput.vmesh);


    // DARK_VISION
    if (length(input.positionRWS) >= DARK_VISION_CUT_LENGTH)
    {
#ifdef WRITE_NORMAL_BUFFER
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
#ifdef WRITE_MSAA_DEPTH
        depthColor = float1(0.0f);
#endif
#elif defined(WRITE_MSAA_DEPTH)
        outNormalBuffer = float4(0.0f, 0.0f, 0.0f, 1.0f);
        depthColor = float1(0.0f);
#elif defined(SCENESELECTIONPASS)
        outColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
#endif
#ifdef _DEPTHOFFSET_ON
        outputDepth = 0.0f;
#endif
        return;
    }


    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

#ifdef _DEPTHOFFSET_ON
    outputDepth = posInput.deviceDepth;
#endif

#ifdef WRITE_NORMAL_BUFFER
    EncodeIntoNormalBuffer(ConvertSurfaceDataToNormalData(surfaceData), posInput.positionSS, outNormalBuffer);
    #ifdef WRITE_MSAA_DEPTH
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
    #endif
#elif defined(WRITE_MSAA_DEPTH) // When we are MSAA depth only without normal buffer
    // Due to the binding order of these two render targets, we need to have them both declared
    outNormalBuffer = float4(0.0, 0.0, 0.0, 1.0);
    // In case we are rendering in MSAA, reading the an MSAA depth buffer is way too expensive. To avoid that, we export the depth to a color buffer
    depthColor = packedInput.vmesh.positionCS.z;
#elif defined(SCENESELECTIONPASS)
    // We use depth prepass for scene selection in the editor, this code allow to output the outline correctly
    outColor = float4(_ObjectId, _PassValue, 1.0, 1.0);
#endif
}


        #pragma vertex Vert
        #pragma fragment Frag

        ENDHLSL
    }
    }

        SubShader
    {
        Tags{ "RenderPipeline" = "HDRenderPipeline" }
        Pass
        {
            Name "IndirectDXR"
            Tags{ "LightMode" = "IndirectDXR" }

            HLSLPROGRAM

            #pragma raytracing test

            #pragma multi_compile _ DEBUG_DISPLAY
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON

            #define SHADERPASS SHADERPASS_RAYTRACING_INDIRECT

        // multi compile that allows us to
        #pragma multi_compile _ DIFFUSE_LIGHTING_ONLY
        #pragma multi_compile _ MULTI_BOUNCE_INDIRECT

        // We use the low shadow maps for raytracing
        #define SHADOW_LOW

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
        #define HAS_LIGHTLOOP
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitRaytracing.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingLightLoop.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitRaytracingData.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassRaytracingIndirect.hlsl"

        ENDHLSL
    }

    Pass
    {
        Name "ForwardDXR"
        Tags{ "LightMode" = "ForwardDXR" }

        HLSLPROGRAM

        #pragma raytracing test

        #pragma multi_compile _ DEBUG_DISPLAY
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON

        #define SHADERPASS SHADERPASS_RAYTRACING_FORWARD

        // We use the low shadow maps for raytracing
        #define SHADOW_LOW

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
        #define HAS_LIGHTLOOP
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitRaytracing.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingLightLoop.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitRaytracingData.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderpassRaytracingForward.hlsl"

        ENDHLSL
    }

    Pass
    {
        Name "GBufferDXR"
        Tags{ "LightMode" = "GBufferDXR" }

        HLSLPROGRAM

        #pragma raytracing test

        #pragma multi_compile _ DEBUG_DISPLAY
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIFFUSE_LIGHTING_ONLY

        #define SHADERPASS SHADERPASS_RAYTRACING_GBUFFER

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitRaytracingData.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitRaytracing.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderpassRaytracingGBuffer.hlsl"

        ENDHLSL
    }

    Pass
    {
        Name "VisibilityDXR"
        Tags{ "LightMode" = "VisibilityDXR" }

        HLSLPROGRAM

        #pragma raytracing test

        #define SHADERPASS SHADERPASS_RAYTRACING_VISIBILITY

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitRaytracingData.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderpassRaytracingVisibility.hlsl"

        ENDHLSL
    }

    Pass
    {
        Name "PathTracingDXR"
        Tags{ "LightMode" = "PathTracingDXR" }

        HLSLPROGRAM

        #pragma raytracing test

        #pragma multi_compile _ DEBUG_DISPLAY

        #define SHADERPASS SHADERPASS_PATH_TRACING

        // This is just because it need to be defined, shadow maps are not used.
        #define SHADOW_LOW

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"

        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
        #define HAS_LIGHTLOOP
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitRaytracing.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingLightLoop.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitRaytracingData.hlsl"
        #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassPathTracing.hlsl"

        ENDHLSL
    }
    }

    CustomEditor "Rendering.HighDefinition.LitGUI"
}
