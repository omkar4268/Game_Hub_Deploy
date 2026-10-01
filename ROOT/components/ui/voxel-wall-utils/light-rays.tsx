"use client";

import React, { useMemo, useRef } from "react";
import { useFrame } from "@react-three/fiber";
import * as THREE from "three";

/**
 * Atmospheric Dust Motes drifting in front of the voxel wall
 */
export function DustMotes({ count = 180 }: { count?: number }) {
  const pointsRef = useRef<THREE.Points>(null!);

  const { positions, velocities } = useMemo(() => {
    const pos = new Float32Array(count * 3);
    const vel = new Float32Array(count * 3);
    for (let i = 0; i < count; i++) {
      pos[i * 3] = (Math.random() - 0.5) * 14;
      pos[i * 3 + 1] = (Math.random() - 0.5) * 10;
      pos[i * 3 + 2] = Math.random() * 4.5 + 0.2;

      vel[i * 3] = (Math.random() - 0.5) * 0.004;
      vel[i * 3 + 1] = Math.random() * 0.006 + 0.002;
      vel[i * 3 + 2] = (Math.random() - 0.5) * 0.003;
    }
    return { positions: pos, velocities: vel };
  }, [count]);

  useFrame(() => {
    if (!pointsRef.current) return;
    const geom = pointsRef.current.geometry;
    const posAttr = geom.attributes.position;
    const arr = posAttr.array as Float32Array;

    for (let i = 0; i < count; i++) {
      arr[i * 3] += velocities[i * 3];
      arr[i * 3 + 1] += velocities[i * 3 + 1];
      arr[i * 3 + 2] += velocities[i * 3 + 2];

      // Respawn if drifts too high
      if (arr[i * 3 + 1] > 6) {
        arr[i * 3 + 1] = -5;
        arr[i * 3] = (Math.random() - 0.5) * 14;
      }
    }
    posAttr.needsUpdate = true;
  });

  return (
    <points ref={pointsRef}>
      <bufferGeometry>
        <bufferAttribute
          attach="attributes-position"
          args={[positions, 3]}
        />
      </bufferGeometry>
      <pointsMaterial
        size={0.045}
        color="#38bdf8"
        transparent
        opacity={0.65}
        blending={THREE.AdditiveBlending}
        depthWrite={false}
      />
    </points>
  );
}

/**
 * Primary Dramatic Light Source (Sun beacon)
 */
export const LightSource = React.forwardRef<THREE.Mesh>((_, ref) => {
  return (
    <mesh ref={ref} position={[3.2, 4.0, 3.5]}>
      <sphereGeometry args={[0.35, 32, 32]} />
      <meshBasicMaterial color="#00f0ff" />
    </mesh>
  );
});
LightSource.displayName = "LightSource";

/**
 * Volumetric Light Rays & Halo Effects
 */
export function LightEffects({ sun }: { sun: THREE.Mesh }) {
  const meshRef = useRef<THREE.Mesh>(null!);

  useFrame((state) => {
    if (!meshRef.current || !sun) return;
    const time = state.clock.getElapsedTime();
    meshRef.current.rotation.z = time * 0.05;
    meshRef.current.position.copy(sun.position);
  });

  return (
    <mesh ref={meshRef} position={[3.2, 4.0, 3.5]}>
      <coneGeometry args={[4.5, 12, 32, 1, true]} />
      <meshBasicMaterial
        color="#00f0ff"
        transparent
        opacity={0.08}
        blending={THREE.AdditiveBlending}
        side={THREE.DoubleSide}
        depthWrite={false}
      />
    </mesh>
  );
}

/**
 * Cinematic Scene Lights Setup
 */
export function SceneLights() {
  return (
    <>
      <ambientLight intensity={0.45} color="#081426" />
      <directionalLight
        position={[3.2, 4.0, 4.0]}
        intensity={2.8}
        color="#00f0ff"
        castShadow
        shadow-mapSize-width={1024}
        shadow-mapSize-height={1024}
      />
      <directionalLight
        position={[-4.0, -3.0, 2.0]}
        intensity={1.1}
        color="#3b82f6"
      />
      <pointLight
        position={[0, 0, 3.5]}
        intensity={1.2}
        distance={8}
        color="#00f0ff"
      />
    </>
  );
}
