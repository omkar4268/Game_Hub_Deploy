"use client";

import { useMemo, useRef } from "react";
import { useFrame } from "@react-three/fiber";
import * as THREE from "three";

const VOXEL_COUNT = 820;
const DOORWAY_Z = -8.0;

export default function VoxelWall() {
  const meshRef = useRef<THREE.InstancedMesh>(null!);
  const tempObject = useMemo(() => new THREE.Object3D(), []);
  const tempColor = useMemo(() => new THREE.Color(), []);

  // Compute 3D perspective 4-walled corridor layout (Floor, Ceiling, Left, Right)
  const voxels = useMemo(() => {
    const list = [];
    const DEPTH_STEPS = 28;

    for (let s = 0; s < DEPTH_STEPS; s++) {
      const p = s / (DEPTH_STEPS - 1);
      const z = -7.8 + p * 13.5;

      const halfW = 1.8 + p * 2.8;
      const halfH = 1.35 + p * 2.2;

      // 1. Floor cubes
      const floorCubes = 8;
      for (let fx = 0; fx < floorCubes; fx++) {
        if (list.length >= VOXEL_COUNT) break;
        const fxNorm = (fx / (floorCubes - 1)) * 2 - 1;
        const x = fxNorm * (halfW + 0.6) + (Math.random() - 0.5) * 0.35;
        const y = -halfH - 0.25 - Math.random() * 0.55;
        list.push({
          x, y, z,
          baseY: y,
          sx: 0.42 + Math.random() * 0.45,
          sy: 0.38 + Math.random() * 0.42,
          sz: 0.38 + Math.random() * 0.42,
          rx: (Math.random() - 0.5) * 0.15,
          ry: (Math.random() - 0.5) * 0.15,
          rz: (Math.random() - 0.5) * 0.12,
          floatPhase: Math.random() * Math.PI * 2,
          floatSpeed: 0.5 + Math.random() * 0.7
        });
      }

      // 2. Ceiling cubes
      const ceilCubes = 7;
      for (let cx = 0; cx < ceilCubes; cx++) {
        if (list.length >= VOXEL_COUNT) break;
        const cxNorm = (cx / (ceilCubes - 1)) * 2 - 1;
        const x = cxNorm * (halfW + 0.6) + (Math.random() - 0.5) * 0.35;
        const y = halfH + 0.25 + Math.random() * 0.55;
        list.push({
          x, y, z,
          baseY: y,
          sx: 0.42 + Math.random() * 0.45,
          sy: 0.38 + Math.random() * 0.42,
          sz: 0.38 + Math.random() * 0.42,
          rx: (Math.random() - 0.5) * 0.15,
          ry: (Math.random() - 0.5) * 0.15,
          rz: (Math.random() - 0.5) * 0.12,
          floatPhase: Math.random() * Math.PI * 2,
          floatSpeed: 0.5 + Math.random() * 0.7
        });
      }

      // 3. Left Wall cubes
      const wallCubes = 7;
      for (let wy = 0; wy < wallCubes; wy++) {
        if (list.length >= VOXEL_COUNT) break;
        const wyNorm = (wy / (wallCubes - 1)) * 2 - 1;
        const y = wyNorm * (halfH + 0.2) + (Math.random() - 0.5) * 0.3;
        const x = -halfW - 0.25 - Math.random() * 0.55;
        list.push({
          x, y, z,
          baseY: y,
          sx: 0.38 + Math.random() * 0.42,
          sy: 0.42 + Math.random() * 0.45,
          sz: 0.38 + Math.random() * 0.42,
          rx: (Math.random() - 0.5) * 0.15,
          ry: (Math.random() - 0.5) * 0.15,
          rz: (Math.random() - 0.5) * 0.12,
          floatPhase: Math.random() * Math.PI * 2,
          floatSpeed: 0.5 + Math.random() * 0.7
        });
      }

      // 4. Right Wall cubes
      for (let wy = 0; wy < wallCubes; wy++) {
        if (list.length >= VOXEL_COUNT) break;
        const wyNorm = (wy / (wallCubes - 1)) * 2 - 1;
        const y = wyNorm * (halfH + 0.2) + (Math.random() - 0.5) * 0.3;
        const x = halfW + 0.25 + Math.random() * 0.55;
        list.push({
          x, y, z,
          baseY: y,
          sx: 0.38 + Math.random() * 0.42,
          sy: 0.42 + Math.random() * 0.45,
          sz: 0.38 + Math.random() * 0.42,
          rx: (Math.random() - 0.5) * 0.15,
          ry: (Math.random() - 0.5) * 0.15,
          rz: (Math.random() - 0.5) * 0.12,
          floatPhase: Math.random() * Math.PI * 2,
          floatSpeed: 0.5 + Math.random() * 0.7
        });
      }
    }

    while (list.length < VOXEL_COUNT) {
      const p = Math.random();
      const z = -7.5 + p * 13.0;
      const halfW = 2.0 + p * 2.8;
      const halfH = 1.5 + p * 2.2;
      const sideX = Math.random() > 0.5 ? 1 : -1;
      const sideY = Math.random() > 0.5 ? 1 : -1;
      const s = 0.35 + Math.random() * 0.45;
      list.push({
        x: sideX * (halfW + 0.2 + Math.random() * 0.8),
        y: sideY * (halfH + 0.2 + Math.random() * 0.8),
        z,
        baseY: sideY * (halfH + 0.2 + Math.random() * 0.8),
        sx: s,
        sy: s,
        sz: s,
        rx: (Math.random() - 0.5) * 0.3,
        ry: (Math.random() - 0.5) * 0.3,
        rz: (Math.random() - 0.5) * 0.3,
        floatPhase: Math.random() * Math.PI * 2,
        floatSpeed: 0.5 + Math.random() * 0.7
      });
    }

    return list;
  }, []);

  useFrame((state) => {
    if (!meshRef.current) return;
    const time = state.clock.getElapsedTime();

    for (let i = 0; i < voxels.length; i++) {
      const v = voxels[i];
      const floatY = v.baseY + Math.sin(time * v.floatSpeed + v.floatPhase) * 0.05;

      tempObject.position.set(v.x, floatY, v.z);
      tempObject.rotation.set(
        v.rx + Math.sin(time * 0.4 + v.floatPhase) * 0.04,
        v.ry + Math.cos(time * 0.3 + v.floatPhase) * 0.04,
        v.rz
      );
      tempObject.scale.set(v.sx, v.sy, v.sz);
      tempObject.updateMatrix();
      meshRef.current.setMatrixAt(i, tempObject.matrix);

      // High contrast monochrome lighting
      const distToDoor = Math.hypot(v.x, v.y, v.z - DOORWAY_Z);
      const normDist = Math.max(0, 1 - distToDoor / 15.0);
      const grayVal = 0.05 + Math.pow(normDist, 1.8) * 0.28;
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
        color="#141416"
        roughness={0.38}
        metalness={0.2}
      />
    </instancedMesh>
  );
}
