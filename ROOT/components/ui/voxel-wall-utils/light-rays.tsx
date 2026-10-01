"use client";

import React, { useMemo, useRef } from "react";
import { useFrame } from "@react-three/fiber";
import * as THREE from "three";

const DOORWAY_Z = -8.0;

/**
 * Atmospheric Dust Motes drifting in the central white light shaft
 */
export function DustMotes({ count = 140 }: { count?: number }) {
  const pointsRef = useRef<THREE.Points>(null!);

  const { positions, velocities } = useMemo(() => {
    const pos = new Float32Array(count * 3);
    const vel = new Float32Array(count * 3);
    for (let i = 0; i < count; i++) {
      pos[i * 3] = (Math.random() - 0.5) * 6.5;
      pos[i * 3 + 1] = (Math.random() - 0.5) * 4.8;
      pos[i * 3 + 2] = -7.5 + Math.random() * 14;

      vel[i * 3] = (Math.random() - 0.5) * 0.003;
      vel[i * 3 + 1] = (Math.random() - 0.5) * 0.003;
      vel[i * 3 + 2] = 0.006 + Math.random() * 0.008;
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

      if (arr[i * 3 + 2] > 7.0) {
        arr[i * 3 + 2] = -7.5;
        arr[i * 3] = (Math.random() - 0.5) * 6.5;
        arr[i * 3 + 1] = (Math.random() - 0.5) * 4.8;
      }
    }
    posAttr.needsUpdate = true;
  });

  return (
    <points ref={pointsRef}>
      <bufferGeometry>
        <bufferAttribute attach="attributes-position" args={[positions, 3]} />
      </bufferGeometry>
      <pointsMaterial
        size={0.038}
        color="#ffffff"
        transparent
        opacity={0.75}
        blending={THREE.AdditiveBlending}
        depthWrite={false}
      />
    </points>
  );
}

/**
 * Central Glowing Pure White Rectangular Doorway / Portal
 */
export const LightSource = React.forwardRef<THREE.Mesh>((_, ref) => {
  return (
    <mesh ref={ref} position={[0, 0, DOORWAY_Z]}>
      <planeGeometry args={[3.6, 2.8]} />
      <meshBasicMaterial color="#ffffff" />
    </mesh>
  );
});
LightSource.displayName = "LightSource";

/**
 * Volumetric God Rays & Light Bloom Texture Effects
 */
export function LightEffects({ sun }: { sun: THREE.Mesh }) {
  const coneRef = useRef<THREE.Mesh>(null!);
  const haloRef = useRef<THREE.Mesh>(null!);

  const glowTexture = useMemo(() => {
    if (typeof document === "undefined") return null;
    const canvas = document.createElement("canvas");
    canvas.width = 512;
    canvas.height = 512;
    const ctx = canvas.getContext("2d");
    if (!ctx) return null;

    const cx = 256,
      cy = 256;
    const radGrad = ctx.createRadialGradient(cx, cy, 30, cx, cy, 250);
    radGrad.addColorStop(0, "rgba(255, 255, 255, 1.0)");
    radGrad.addColorStop(0.18, "rgba(255, 255, 255, 0.85)");
    radGrad.addColorStop(0.45, "rgba(220, 235, 255, 0.35)");
    radGrad.addColorStop(0.75, "rgba(180, 210, 255, 0.10)");
    radGrad.addColorStop(1.0, "rgba(0, 0, 0, 0)");
    ctx.fillStyle = radGrad;
    ctx.fillRect(0, 0, 512, 512);

    ctx.save();
    ctx.translate(cx, cy);
    for (let i = 0; i < 16; i++) {
      ctx.rotate((Math.PI * 2) / 16);
      const rayGrad = ctx.createLinearGradient(0, 0, 240, 0);
      rayGrad.addColorStop(0, "rgba(255, 255, 255, 0.45)");
      rayGrad.addColorStop(0.4, "rgba(255, 255, 255, 0.15)");
      rayGrad.addColorStop(1, "rgba(255, 255, 255, 0)");
      ctx.fillStyle = rayGrad;
      ctx.beginPath();
      ctx.moveTo(0, -6);
      ctx.lineTo(240, -18);
      ctx.lineTo(240, 18);
      ctx.lineTo(0, 6);
      ctx.fill();
    }
    ctx.restore();

    const tex = new THREE.CanvasTexture(canvas);
    tex.generateMipmaps = false;
    tex.minFilter = THREE.LinearFilter;
    return tex;
  }, []);

  useFrame((state) => {
    const time = state.clock.getElapsedTime();
    if (coneRef.current) coneRef.current.rotation.z = time * 0.03;
    if (haloRef.current) haloRef.current.rotation.z = -time * 0.015;
  });

  return (
    <group position={[0, 0, DOORWAY_Z]}>
      {glowTexture && (
        <>
          <mesh position={[0, 0, 0.08]}>
            <planeGeometry args={[8.2, 6.8]} />
            <meshBasicMaterial
              map={glowTexture}
              transparent
              blending={THREE.AdditiveBlending}
              opacity={0.95}
              depthWrite={false}
            />
          </mesh>
          <mesh ref={haloRef} position={[0, 0, 0.15]}>
            <planeGeometry args={[16.0, 13.0]} />
            <meshBasicMaterial
              map={glowTexture}
              transparent
              blending={THREE.AdditiveBlending}
              opacity={0.32}
              depthWrite={false}
            />
          </mesh>
        </>
      )}

      {/* Volumetric cone projecting forward */}
      <mesh
        ref={coneRef}
        rotation={[Math.PI / 2, 0, 0]}
        position={[0, 0, 6.5]}
      >
        <cylinderGeometry args={[1.6, 7.5, 14.5, 32, 1, true]} />
        <meshBasicMaterial
          color="#ffffff"
          transparent
          opacity={0.055}
          blending={THREE.AdditiveBlending}
          side={THREE.DoubleSide}
          depthWrite={false}
        />
      </mesh>
    </group>
  );
}

/**
 * Scene Lights: Pure White Backlight from the Center Doorway
 */
export function SceneLights() {
  return (
    <>
      <ambientLight intensity={0.7} color="#141414" />
      <pointLight
        position={[0, 0, -7.6]}
        intensity={5.2}
        distance={28}
        decay={1.2}
        color="#ffffff"
      />
      <directionalLight position={[0, -4, 4]} intensity={0.4} color="#2a2a2a" />
    </>
  );
}
