#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;
uniform float GameTime;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
    vec3 AlignedPosition = mod(abs(Position), 16) * sign(Position);
    vec3 Disposition = vec3(
        sin(AlignedPosition.x * 1.3 - AlignedPosition.z * 0.7 + 0.0) * (0.6 + sin(AlignedPosition.y * 1.3 + 1.0)) * 0.12,
        sin(AlignedPosition.x * 1.1 + AlignedPosition.z * 1.5 + 3.0) * (0.6 + cos(AlignedPosition.y * 1.5 + 0.0)) * 0.12,
        cos(AlignedPosition.x * 0.7 + AlignedPosition.z * 1.4 + 7.0) * (0.6 + sin(AlignedPosition.y * 1.2 + 9.0)) * 0.12
    );

    gl_Position = ProjMat * ModelViewMat * (vec4(Position + ChunkOffset + Disposition, 1.0));

    vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset + Disposition, 1.0)).xyz);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
