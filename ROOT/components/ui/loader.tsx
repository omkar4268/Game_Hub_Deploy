"use client";

import * as React from "react";
import { motion } from "motion/react";
import { cn } from "@/lib/utils";

interface LoaderProps extends React.HTMLAttributes<HTMLDivElement> {
  title?: string;
  subtitle?: string;
  size?: "sm" | "md" | "lg";
}

export default function Loader({
  title = "Configuring your account...",
  subtitle = "Please wait while we prepare everything for you",
  size = "md",
  className,
  ...props
}: LoaderProps) {
  const sizeConfig = {
    sm: {
      container: "size-20",
      titleClass: "text-sm/tight font-medium",
      subtitleClass: "text-xs/relaxed",
      spacing: "space-y-2",
      maxWidth: "max-w-48",
    },
    md: {
      container: "size-32",
      titleClass: "text-base/snug font-medium",
      subtitleClass: "text-sm/relaxed",
      spacing: "space-y-3",
      maxWidth: "max-w-56",
    },
    lg: {
      container: "size-40",
      titleClass: "text-lg/tight font-semibold",
      subtitleClass: "text-base/relaxed",
      spacing: "space-y-4",
      maxWidth: "max-w-64",
    },
  };

  const config = sizeConfig[size];

  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center gap-8 p-8",
        className,
      )}
      {...props}
    >
      {/* Enhanced Monochrome Loader */}
      <motion.div
        animate={{
          scale: [1, 1.02, 1],
        }}
        className={cn("relative", config.container)}
        transition={{
          duration: 4,
          repeat: Number.POSITIVE_INFINITY,
          ease: [0.4, 0, 0.6, 1],
        }}
      >
        {/* Outer elegant ring with shimmer */}
        <motion.div
          animate={{
            rotate: [0, 360],
          }}
          className="absolute inset-0 rounded-full"
          style={{
            background:
              "conic-gradient(from 0deg, transparent 0deg, rgb(0, 0, 0) 90deg, transparent 180deg)",
            mask: "radial-gradient(circle at 50% 50%, transparent 66%, black 67%)",
            WebkitMask:
              "radial-gradient(circle at 50% 50%, transparent 66%, black 67%)",
          }}
          transition={{
            duration: 3,
            repeat: Number.POSITIVE_INFINITY,
            ease: "linear",
          }}
        />

        {/* Counter-rotating middle ring */}
        <motion.div
          animate={{
            rotate: [360, 0],
          }}
          className="absolute inset-2 rounded-full"
          style={{
            background:
              "conic-gradient(from 180deg, transparent 0deg, rgb(0, 0, 0) 180deg, transparent 270deg)",
            mask: "radial-gradient(circle at 50% 50%, transparent 64%, black 65%)",
            WebkitMask:
              "radial-gradient(circle at 50% 50%, transparent 64%, black 65%)",
          }}
          transition={{
            duration: 2.5,
            repeat: Number.POSITIVE_INFINITY,
            ease: "linear",
          }}
        />

        {/* Inner pulsing ring with subtle gradient */}
        <motion.div
          animate={{
            rotate: [0, 360],
            scale: [0.98, 1.02, 0.98],
          }}
          className="absolute inset-4 rounded-full"
          style={{
            background:
              "conic-gradient(from 90deg, transparent 0deg, rgb(0, 0, 0) 90deg, transparent 135deg)",
            mask: "radial-gradient(circle at 50% 50%, transparent 60%, black 62%)",
            WebkitMask:
              "radial-gradient(circle at 50% 50%, transparent 60%, black 62%)",
          }}
          transition={{
            rotate: {
              duration: 2,
              repeat: Number.POSITIVE_INFINITY,
              ease: "linear",
            },
            scale: {
              duration: 3,
              repeat: Number.POSITIVE_INFINITY,
              ease: [0.4, 0, 0.6, 1],
            },
          }}
        />

        {/* Center precision dot */}
        <div className="absolute inset-0 m-auto size-1.5 rounded-full bg-black/80 dark:bg-white/80" />

        {/* Minimal accent particles */}
        <motion.div
          animate={{
            rotate: [0, 360],
          }}
          className="absolute inset-0"
          transition={{
            duration: 8,
            repeat: Number.POSITIVE_INFINITY,
            ease: "linear",
          }}
        >
          <div className="absolute top-0 left-1/2 -translate-x-1/2 size-1 rounded-full bg-black/60 dark:bg-white/60" />
          <div className="absolute bottom-0 left-1/2 -translate-x-1/2 size-0.5 rounded-full bg-black/40 dark:bg-white/40" />
        </motion.div>
      </motion.div>

      {/* Modern typography with subtle breathing animation */}
      {(title || subtitle) && (
        <motion.div
          animate={{
            opacity: [0.7, 1, 0.7],
          }}
          className={cn("text-center", config.spacing, config.maxWidth)}
          transition={{
            duration: 3,
            repeat: Number.POSITIVE_INFINITY,
            ease: [0.4, 0, 0.6, 1],
          }}
        >
          {title && (
            <h3
              className={cn(
                "tracking-tight text-neutral-900 dark:text-neutral-100",
                config.titleClass,
              )}
            >
              {title}
            </h3>
          )}
          {subtitle && (
            <p
              className={cn(
                "text-muted-foreground tracking-normal",
                config.subtitleClass,
              )}
            >
              {subtitle}
            </p>
          )}
        </motion.div>
      )}
    </div>
  );
}
