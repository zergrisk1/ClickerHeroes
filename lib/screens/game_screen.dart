import 'package:flutter/material.dart';
import 'dart:async';
import '../models/hero.dart';
import '../models/monster.dart';
import '../utils/constants.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late MyHero _hero;
  late Monster _monster;
  bool _showCriticalHit = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _hero = MyHero(
      clickAttackPower: BASE_CLICK_ATTACK_POWER,
      tickAttackPower: BASE_TICK_ATTACK_POWER,
      tickRate: 1,
      maxHealth: INITIAL_MAX_HEALTH,
      currentHealth: INITIAL_MAX_HEALTH,
      maxMana: INITIAL_MAX_MANA,
      currentMana: INITIAL_MAX_MANA,
      criticalHitChance: BASE_CRITICAL_HIT_CHANCE,
      criticalHitDamage: BASE_CLICK_ATTACK_POWER * BigInt.from(CRITICAL_HIT_DAMAGE_MULTIPLIER),
      level: 1,
      maxExperience: INITIAL_MAX_EXPERIENCE,
      currentExperience: INITIAL_EXPERIENCE,
      gold: INITIAL_GOLD,
      diamonds: INITIAL_DIAMONDS,
    );
    _spawnMonster();
  }

  void _spawnMonster() {
    setState(() {
      _monster = Monster(
        health: BigInt.from(50 + _hero.level * 10),
        attackPower: BigInt.from(5 + _hero.level * 2),
        level: _hero.level,
        experienceReward: BigInt.from(20 + _hero.level * 5),
        goldReward: BigInt.from(10 + _hero.level * 2),
      );
    });
  }

  void _attackMonster() {
    setState(() {
      bool isCritical = _hero.isCriticalHit();
      BigInt damage = isCritical ? _hero.criticalHitDamage : _hero.clickAttackPower;
      _monster.takeDamage(damage);

      if (isCritical) {
        _showCriticalHit = true;
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            _showCriticalHit = false;
          });
        });
      }

      if (_monster.isDead()) {
        _monster.rewardHero(_hero);
        _spawnMonster();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Click Battle Game")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("영웅 레벨: ${_hero.level}"),
            Text("경험치: ${_hero.currentExperience} / ${_hero.maxExperience}"),
            Text("Gold: ${_hero.gold}"),
            SizedBox(height: 20),
            if (_showCriticalHit)
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                width: 100,
                height: 100,
                color: Colors.red,
              ),
            if (_showCriticalHit)
              Text(
                "치명타! ${_hero.criticalHitDamage}",
                style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            Text("몬스터 체력: ${_monster.health}"),
            ElevatedButton(
              onPressed: _attackMonster,
              child: Text("공격하기"),
            ),
          ],
        ),
      ),
    );
  }
}