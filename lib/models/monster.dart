import 'dart:math';
import '../utils/constants.dart';
import 'hero.dart';
import 'package:flutter/material.dart';

class Monster {
  // Params
  BigInt tickAttackPower; // 틱당 공격력
  int tickRate; // 틱 rate
  BigInt maxHealth; // 최대 체력
  BigInt currentHealth; // 현재 체력
  BigInt maxMana; // 최대 마나
  BigInt currentMana; // 현재 마나
  double criticalHitChance; // 치명타 확률
  BigInt criticalHitDamage; // 치명타 공격력
  int level; // 레벨
  BigInt experienceReward; // 경험치 보상
  BigInt goldReward; // 지급하는 금화
  BigInt diamondsReward; // 지급하는 다이아몬드
  double x; // 몬스터의 x 좌표
  double y; // 몬스터의 y 좌표

  Monster({
    required this.tickAttackPower,
    required this.tickRate,
    required this.maxHealth,
    required this.currentHealth,
    required this.maxMana,
    required this.currentMana,
    required this.criticalHitChance,
    required this.criticalHitDamage,
    required this.level,
    required this.experienceReward,
    required this.goldReward,
    required this.diamondsReward,
    required this.x,
    required this.y,
  });

  // 1. 몬스터가 영웅에게 공격하는 이벤트
  void attack(MyHero hero) {
    if (!isDead()) {
      bool isCritical = Random().nextDouble() < criticalHitChance;
      BigInt damage = isCritical ? criticalHitDamage : tickAttackPower;
      hero.takeDamage(damage);
      if (isCritical) {
        print('몬스터가 치명타를 입혔습니다!');
      }
    }
  }

  // 2. 몬스터의 체력이 감소하는 이벤트
  void takeDamage(BigInt damage) {
    currentHealth -= damage;
    if (currentHealth < BigInt.zero) {
      currentHealth = BigInt.zero; // 체력이 0 이하로 떨어지지 않도록
    }
    print('몬스터의 남은 체력: $currentHealth');
  }

  // 3. 몬스터의 현재 체력이 <= 0이면 사망 판정
  bool isDead() {
    return currentHealth <= BigInt.zero;
  }

  // 4. 몬스터 처치 시 보상 지급
  void rewardHero(MyHero hero) {
    if (isDead()) {
      hero.gainExperience(experienceReward);
      hero.gold += goldReward;
      hero.diamonds += diamondsReward;
      print('영웅에게 $experienceReward 경험치와 $goldReward 금화가 지급되었습니다.');
      print('영웅에게 $diamondsReward 다이아몬드가 지급되었습니다.');
    } else {
      print('몬스터가 아직 살아있습니다.');
    }
  }
 Widget drawCreature(){
    return Stack(
      children: [
        drawHealthBar(),
        drawAnimation(),
      ],
    );
 }
 Widget drawAnimation() {
   return Positioned(
     left: x,
     top: y + MONSTER_HEALTH_BAR_HEIGHT + 20,
     child: Image.asset('assets/images/monster.png', width: 50, height: 50),
   );
 }
// 5. 몬스터의 체력바를 그리는 메서드
  Widget drawHealthBar() {
    double healthPercentage = currentHealth.toDouble() / maxHealth.toDouble();
    Color healthColor = Color.lerp(Colors.red, Colors.green, healthPercentage)!;

    return Positioned(
      left: x,
      top: y - MONSTER_HEALTH_BAR_HEIGHT - 5, // 몬스터 위치의 상단에 체력바를 위치시킴, 몬스터와의 간격 추가
      child: Container(
        width: MONSTER_HEALTH_BAR_WIDTH * healthPercentage, // 현재 체력에 비례하여 넓이 조정
        height: MONSTER_HEALTH_BAR_HEIGHT, // 체력바의 높이
        decoration: BoxDecoration(
          color: healthColor,
          borderRadius: BorderRadius.circular(4), // 모서리를 둥글게
        ),
      ),
    );
  }
}
