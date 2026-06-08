<template>
  <div class="flex flex-col items-center gap-6">
    <svg :width="size" :height="size" viewBox="0 0 100 100" class="shrink-0">
      <circle cx="50" cy="50" r="40" fill="none" stroke="#f0f0f0" stroke-width="18" />
      <path
        v-for="(slice, i) in slices"
        :key="i"
        :d="slice.path"
        :fill="slice.color"
        :transform="`rotate(${slice.rotateAngle} 50 50)`"
        class="transition-all duration-500"
      />
      <circle cx="50" cy="50" r="18" fill="white" />
      <text x="50" y="46" text-anchor="middle" class="text-[18px] font-bold fill-espresso" font-size="18" font-weight="700">{{ total }}</text>
      <text x="50" y="60" text-anchor="middle" class="text-[6px] fill-cocoa/50" font-size="6">total</text>
    </svg>
    <div class="grid grid-cols-2 gap-x-8 gap-y-2 w-full">
      <div v-for="(slice, i) in slices" :key="i" class="flex items-center gap-2 text-xs">
        <span class="w-2.5 h-2.5 rounded-sm shrink-0" :style="{ backgroundColor: slice.color }"></span>
        <span class="text-cocoa/70 truncate">{{ slice.emoji }} {{ slice.label }}</span>
        <span class="ml-auto font-semibold text-espresso tabular-nums">{{ slice.percent }}%</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from "vue";

const props = defineProps<{
  data: Array<{ label: string; emoji: string; count: number; percent: number }>;
  size?: number;
}>();

const PALETTE = [
  "#E57373", "#FFB74D", "#FFD54F", "#81C784", "#64B5F6",
  "#BA68C8", "#F06292", "#A1887F", "#4DB6AC", "#90A4AE"
];

const slices = computed(() => {
  const total = props.data.reduce((sum, d) => sum + d.count, 0);
  if (total === 0) return [];
  let currentAngle = 0;
  return props.data.map((d, i) => {
    const percent = d.count / total;
    const angle = percent * 360;
    const startAngle = currentAngle;
    currentAngle += angle;

    const startRad = ((startAngle - 90) * Math.PI) / 180;
    const endRad = ((startAngle + angle - 90) * Math.PI) / 180;
    const x1 = 50 + 40 * Math.cos(startRad);
    const y1 = 50 + 40 * Math.sin(startRad);
    const x2 = 50 + 40 * Math.cos(endRad);
    const y2 = 50 + 40 * Math.sin(endRad);
    const largeArc = angle > 180 ? 1 : 0;

    return {
      path: `M 50 50 L ${x1} ${y1} A 40 40 0 ${largeArc} 1 ${x2} ${y2} Z`,
      color: PALETTE[i % PALETTE.length],
      rotateAngle: 0,
      label: d.label,
      emoji: d.emoji,
      percent: d.percent
    };
  });
});

const total = computed(() => props.data.reduce((sum, d) => sum + d.count, 0));
</script>
