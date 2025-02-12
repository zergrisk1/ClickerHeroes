import 'dart:math';
import 'hero.dart';

class Monster {
  // Params
  BigInt health; // 몬스터의 체력
  BigInt attackPower; // 몬스터의 공격력
  int level; // 몬스터의 레벨
  BigInt experienceReward; // 처치 시 보상 경험치
  BigInt goldReward; // 처치 시 보상 금화

  Monster({
    required this.health,
    required this.attackPower,
    required this.level,
    required this.experienceReward,
    required this.goldReward,
  });

  // 1. 몬스터가 영웅에게 공격하는 이벤트
  void attack(MyHero hero) {
    if (!isDead()) {
      BigInt damage = attackPower;
      hero.takeDamage(damage);
      print('몬스터가 영웅에게 $damage 피해를 입혔습니다.');
    } else {
      print('몬스터는 이미 사망했습니다.');
    }
  }

  // 2. 몬스터의 체력이 감소하는 이벤트
  void takeDamage(BigInt damage) {
    health -= damage;
    if (health < BigInt.zero) {
      health = BigInt.zero; // 체력이 0 이하로 떨어지지 않도록
    }
    print('몬스터의 남은 체력: $health');
  }

  // 3. 몬스터의 현재 체력이 <= 0이면 사망 판정
  bool isDead() {
    return health <= BigInt.zero;
  }

  // 4. 몬스터 처치 시 보상 지급
  void rewardHero(MyHero hero) {
    if (isDead()) {
      hero.gainExperience(experienceReward);
      hero.gold += goldReward;
      print('영웅에게 $experienceReward 경험치와 $goldReward 금화가 지급되었습니다.');
    } else {
      print('몬스터가 아직 살아있습니다.');
    }
  }
}
