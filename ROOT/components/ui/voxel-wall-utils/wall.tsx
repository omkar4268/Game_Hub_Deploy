"use client";

import { useMemo, useRef } from "react";
import { useFrame } from "@react-three/fiber";
import * as THREE from "three";

const COLS = 34;
const ROWS = 22;
const VOXEL_SIZE = 0.36;
const GAP = 0.05;
const STEP = VOXEL_SIZE + GAP;

export default function VoxelWall() {
  const meshRef = useRef<THREE.InstancedMesh>(null!);
  const tempObject = useMemo(() => new THREE.Object3D(), []);
  const tempColor = useMemo(() => new THREE.Color(), []);

  // Compute grid initial layout
  const grid = useMemo(() => {
    const items: { x: number; y: number; baseZ: number; phase: number }[] = [];
    const offsetX = ((COLS - 1) * STEP) / 2;
    const offsetY = ((ROWS - 1) * STEP) / 2;

    for (let r = 0; r < ROWS; r++) {
      for (let c = 0; c < COLS; c++) {
        const x = c * STEP - offsetX;
        const y = r * STEP - offsetY;
        const distCenter = Math.hypot(x, y);
        items.push({
          x,
          y,
          baseZ: -Math.cos(distCenter * 0.4) * 0.3,
          phase: (x * 0.5 + y * 0.3),
        });
      }
    }
    return items;
  }, []);

  useFrame((state) => {
    if (!meshRef.current) return;
    const time = state.clock.getElapsedTime();
    const ptrX = (state.pointer.x * (COLS * STEP)) / 2;
    const ptrY = (state.pointer.y * (ROWS * STEP)) / 2;

    for (let i = 0; i < grid.length; i++) {
      const item = grid[i];

      // Procedural undulating wave
      const wave =
        Math.sin(time * 1.6 + item.phase) * 0.25 +
        Math.cos(time * 0.9 - item.y * 0.6) * 0.15;

      // Pointer interactive ripple displacement
      const dx = item.x - ptrX;
      const dy = item.y - ptrY;
      const mouseDist = Math.hypot(dx, dy);
      const mouseInfluence = Math.max(0, 1 - mouseDist / 2.8);
      const mouseElevation = Math.sin(mouseInfluence * Math.PI) * 0.75;

      const z = item.baseZ + wave + mouseElevation;

      tempObject.position.set(item.x, item.y, z);
      
      // Dynamic scaling on elevation
      const scaleZ = 1 + mouseElevation * 1.2;
      tempObject.scale.set(1, 1, Math.max(0.4, scaleZ));
      tempObject.updateMatrix();
      meshRef.current.setMatrixAt(i, tempObject.matrix);

      // Subtle dynamic color accent based on height & cursor interaction
      const elevationRatio = (z + 0.5) / 1.5;
      const r = THREE.MathUtils.lerp(0.04, 0.0, elevationRatio);
      const g = THREE.MathUtils.lerp(0.12, 0.85, Math.max(0, mouseInfluence));
      const b = THREE.MathUtils.lerp(0.24, 1.0, elevationRatio);
      tempColor.setRGB(r, g, b);
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
      args={[undefined, undefined, COLS * ROWS]}
      castShadow
      receiveShadow
    >
      <boxGeometry args={[VOXEL_SIZE, VOXEL_SIZE, 0.6]} />
      <meshStandardMaterial
        roughness={0.25}
        metalness={0.4}
        envMapIntensity={0.8}
      />
    </instancedMesh>
  );
}
