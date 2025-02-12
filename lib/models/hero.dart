import 'dart:math';

class MyHero {
  // Params
  BigInt clickAttackPower; // 클릭 공격력
  BigInt tickAttackPower; // 틱당 공격력
  int tickRate; // 틱 rate
  BigInt maxHealth; // 최대 체력
  BigInt currentHealth; // 현재 체력
  BigInt maxMana; // 최대 마나
  BigInt currentMana; // 현재 마나
  double criticalHitChance; // 치명타 확률
  BigInt criticalHitDamage; // 치명타 공격력
  int level; // 레벨
  BigInt maxExperience; // 최대 경험치
  BigInt currentExperience; // 필요한 경험치
  BigInt gold; // 보유한 금화
  BigInt diamonds; // 보유한 다이아몬드

  MyHero({
    required this.clickAttackPower,
    required this.tickAttackPower,
    required this.tickRate,
    required this.maxHealth,
    required this.currentHealth,
    required this.maxMana,
    required this.currentMana,
    required this.criticalHitChance,
    required this.criticalHitDamage,
    required this.level,
    required this.maxExperience,
    required this.currentExperience,
    required this.gold,
    required this.diamonds,
  });

  // 1. 영웅의 체력이 감소하는 이벤트
  void takeDamage(BigInt damage) {
    currentHealth -= damage;
    if (currentHealth < BigInt.zero) {
      currentHealth = BigInt.zero; // 체력이 0 이하로 떨어지지 않도록
    }
    print('$currentHealth 체력 남음');
  }

  // 2. 경험치를 획득하며 레벨업 판단
  void gainExperience(BigInt experience) {
    currentExperience += experience;
    if (currentExperience >= maxExperience) {
      levelUp();
    }
  }

  void levelUp() {
    level++;
    currentExperience -= maxExperience; // 남은 경험치
    maxExperience = maxExperience * BigInt.from(1.2); // 다음 레벨의 최대 경험치 증가
    print('레벨업! 현재 레벨: $level');
  }

  // 3. 영웅의 현재 체력이 <= 0이면 사망 판정
  bool isDead() {
    return currentHealth <= BigInt.zero;
  }

  // 4. 치명타가 발동했는지 여부 확인
  bool isCriticalHit() {
    Random random = Random();
    double chance = random.nextDouble(); // 0.0 ~ 1.0 사이의 랜덤 값 생성
    return chance < criticalHitChance; // 치명타 확률과 비교
  }
}