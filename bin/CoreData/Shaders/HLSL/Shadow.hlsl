#include "Uniforms.hlsl"
#include "Samplers.hlsl"
#include "Transform.hlsl"

void VS(float4 iPos : POSITION,
    #ifdef SKINNED
        float4 iBlendWeights : BLENDWEIGHT,
        int4 iBlendIndices : BLENDINDICES,
    #endif
    #ifdef INSTANCED
        float4x3 iModelInstance : TEXCOORD2,
    #endif
    float2 iTexCoord : TEXCOORD0,
    #ifdef VSM_SHADOW
        out float3 oTexCoord : TEXCOORD0,
    #else
        out float2 oTexCoord : TEXCOORD0,
    #endif
    out float4 oPos : OUTPOSITION)
{
    float4x3 modelMatrix = iModelMatrix;
    float3 worldPos = GetWorldPos(modelMatrix);
    oPos = GetClipPos(worldPos);
    #ifdef VSM_SHADOW
        oTexCoord = float3(GetTexCoord(iTexCoord), GetDepth(oPos));
    #else
        oTexCoord = GetTexCoord(iTexCoord);
    #endif
}

void PS(
    #ifdef VSM_SHADOW
        float3 iTexCoord : TEXCOORD0,
    #else
        float2 iTexCoord : TEXCOORD0,
    #endif
    out float4 oColor : OUTCOLOR0)
{
    #ifdef ALPHAMASK
        float alpha = Sample2D(DiffMap, iTexCoord.xy).a;
        if (alpha < 0.5)
            discard;
    #endif

    #ifdef VSM_SHADOW
        float depth = iTexCoord.z;
        oColor = float4(depth, depth * depth, 1.0, 1.0);
    #else
        oColor = 1.0;
    #endif
}
