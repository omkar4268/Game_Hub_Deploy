"use client";

import { useFrame } from "@react-three/fiber";
import * as THREE from "three";

export default function CameraRig() {
  useFrame((state) => {
    // Smooth cinematic parallax following the pointer
    const targetX = 0.15 + state.pointer.x * 0.75;
    const targetY = -2.35 + state.pointer.y * 0.5;

    state.camera.position.x = THREE.MathUtils.lerp(
      state.camera.position.x,
      targetX,
      0.05
    );
    state.camera.position.y = THREE.MathUtils.lerp(
      state.camera.position.y,
      targetY,
      0.05
    );

    // Look toward center of the voxel wall
    state.camera.lookAt(0, 0, 0);
  });

  return null;
}
