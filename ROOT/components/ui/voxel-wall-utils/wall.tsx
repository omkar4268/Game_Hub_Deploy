"use client";

import { useMemo, useRef } from "react";
import { useFrame } from "@react-three/fiber";
import * as THREE from "three";

const VOXEL_COUNT = 520;
const DOORWAY_Z = -8.0;

export default function VoxelWall() {
  const meshRef = useRef<THREE.InstancedMesh>(null!);
  const tempObject = useMemo(() => new THREE.Object3D(), []);
  const tempColor = useMemo(() => new THREE.Color(), []);

  // Compute 3D perspective tunnel layout
  const voxels = useMemo(() => {
    const list = [];
    for (let i = 0; i < VOXEL_COUNT; i++) {
      const progress = i / VOXEL_COUNT;
      const z = -7.8 + progress * 14.3;

      const pNorm = (z - (-7.8)) / 14.3; // 0 to 1
      const rMin = 1.95 + pNorm * 2.6;
      const rMax = 3.6 + pNorm * 4.6;
      const r = rMin + Math.random() * (rMax - rMin);

      const angle = Math.random() * Math.PI * 2;
      const x = Math.cos(angle) * r + (Math.random() - 0.5) * 0.45;
      const y = Math.sin(angle) * (r * 0.72) + (Math.random() - 0.5) * 0.45;

      const baseSize = 0.32 + Math.random() * 0.45;
      const sx = baseSize * (0.85 + Math.random() * 0.3);
      const sy = baseSize * (0.85 + Math.random() * 0.3);
      const sz = baseSize * (0.85 + Math.random() * 0.3);

      const rx = (Math.random() - 0.5) * 0.65;
      const ry = (Math.random() - 0.5) * 0.65;
      const rz = (Math.random() - 0.5) * 0.65;

      list.push({
        x, y, z,
        baseY: y,
        sx, sy, sz,
        rx, ry, rz,
        floatPhase: Math.random() * Math.PI * 2,
        floatSpeed: 0.6 + Math.random() * 0.8
      });
    }
    return list;
  }, []);

  useFrame((state) => {
    if (!meshRef.current) return;
    const time = state.clock.getElapsedTime();

    for (let i = 0; i < voxels.length; i++) {
      const v = voxels[i];
      const floatY = v.baseY + Math.sin(time * v.floatSpeed + v.floatPhase) * 0.06;

      tempObject.position.set(v.x, floatY, v.z);
      tempObject.rotation.set(
        v.rx + Math.sin(time * 0.4 + v.floatPhase) * 0.05,
        v.ry + Math.cos(time * 0.3 + v.floatPhase) * 0.05,
        v.rz
      );
      tempObject.scale.set(v.sx, v.sy, v.sz);
      tempObject.updateMatrix();
      meshRef.current.setMatrixAt(i, tempObject.matrix);

      // Monochrome lighting gradient
      const distToDoor = Math.hypot(v.x, v.y, v.z - DOORWAY_Z);
      const lightRatio = Math.max(0, 1 - distToDoor / 14);
      const grayVal = 0.06 + lightRatio * 0.16;
      tempColor.setRGB(grayVal, grayVal, grayVal);
      meshRef.current.setColorAt(i, tempColor);
    }

    meshRef.current.instanceMatrix.needsUpdate = true;
    if (meshRef.current.instanceColor) {
      meshRef.current.instanceColor.needsUpdate = true;
    }
  });

  return (
    <instancedMesh
      ref={meshRef}
      args={[undefined, undefined, VOXEL_COUNT]}
      castShadow
      receiveShadow
    >
      <boxGeometry args={[1, 1, 1]} />
      <meshStandardMaterial
        color="#181818"
        roughness={0.35}
        metalness={0.22}
      />
    </instancedMesh>
  );
}
