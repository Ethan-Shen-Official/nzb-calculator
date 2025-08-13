import Left from "../components/Left.vue";

interface LeftInputs {
    difficulty: number;
    ban: number;
    ending: number;
}

interface RightInputs {

}

interface MiddleInputs {
  emergency: number;
  special: number;
  hole: number;
}

export function calculate(left: LeftInputs, middle: MiddleInputs, right: RightInputs) {
  // 在这里实现你的计算逻辑
  const result = left.difficulty + left.ban + left.ending +
                middle.emergency + middle.special + middle.hole;
  return result;
}