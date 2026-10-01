"use client";

import { Suspense, useEffect, useLayoutEffect, useRef, useState } from "react";
import { Canvas } from "@react-three/fiber";
import * as THREE from "three";

import CameraRig from "./voxel-wall-utils/camera-rig";
import {
  DustMotes,
  LightEffects,
  LightSource,
  SceneLights,
} from "./voxel-wall-utils/light-rays";
import VoxelWall from "./voxel-wall-utils/wall";

interface VoxelWallSceneProps {
  className?: string;
  height?: string | number;
}

function SceneContents() {
  const sunRef = useRef<THREE.Mesh>(null!);
  const [sun, setSun] = useState<THREE.Mesh | null>(null);

  useLayoutEffect(() => {
    if (sunRef.current) setSun(sunRef.current);
  }, []);

  return (
    <>
      <SceneLights />
      <VoxelWall />
      <LightSource ref={sunRef} />
      <DustMotes />
      <CameraRig />
      {sun && <LightEffects sun={sun} />}
    </>
  );
}

export default function VoxelWallScene({
  className,
  height = "100%",
}: VoxelWallSceneProps) {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <div
      className={className}
      style={{ width: "100%", height, background: "#000000" }}
    >
      {mounted ? (
        <Canvas
          dpr={[1, 2]}
          shadows
          camera={{ position: [0, 0, 7.8], fov: 54, near: 0.1, far: 45 }}
          gl={{
            antialias: false,
            alpha: false,
            toneMapping: THREE.ACESFilmicToneMapping,
            toneMappingExposure: 1.15,
          }}
          style={{ width: "100%", height: "100%" }}
        >
          <color attach="background" args={["#000000"]} />
          <fog attach="fog" args={["#000000", 6, 22]} />
          <Suspense fallback={null}>
            <SceneContents />
          </Suspense>
        </Canvas>
      ) : null}
    </div>
  );
}
