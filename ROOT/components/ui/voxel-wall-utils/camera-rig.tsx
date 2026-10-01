"use client";

import { useFrame } from "@react-three/fiber";
import * as THREE from "three";

const DOORWAY_Z = -8.0;

export default function CameraRig() {
  useFrame((state) => {
    // Parallax tracking pointer while keeping center white doorway aligned
    const targetX = state.pointer.x * 0.55;
    const targetY = state.pointer.y * 0.38;

    state.camera.position.x = THREE.MathUtils.lerp(
      state.camera.position.x,
      targetX,
      0.04
    );
    state.camera.position.y = THREE.MathUtils.lerp(
      state.camera.position.y,
      targetY,
      0.04
    );

    // Look straight towards the central glowing doorway
    state.camera.lookAt(0, 0, DOORWAY_Z);
  });

  return null;
}
