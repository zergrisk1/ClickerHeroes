import 'package:flutter/material.dart';
import 'dart:async';
import '../models/hero.dart';
import '../models/monster.dart';
import '../services/game_service.dart';
import '../utils/constants.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameService _game_service;
  late MyHero _hero;
  late Monster _monster;
  late String formattedGameTime = "00:00";
  //setState로 게임 시간 관리
  bool _showCriticalHit = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _reRenderPerFrame() {
    setState(() {
      formattedGameTime = _game_service.getFormattedGameTime();
    });
  }
  void _initializeGame() {
    _game_service = GameService();
    _game_service.gameMinutesStream.listen((_) {
      _reRenderPerFrame();
    });
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
        tickAttackPower: BigInt.from(5),
        tickRate: 1,
        maxHealth: BigInt.from(100),
        currentHealth: BigInt.from(100),
        maxMana: BigInt.from(50),
        currentMana: BigInt.from(50),
        criticalHitChance: 0.1,
        criticalHitDamage: BigInt.from(20),
        level: 1,
        experienceReward: BigInt.from(50),
        goldReward: BigInt.from(100),
        diamondsReward: BigInt.from(10),
        x: 100,
        y: 100,
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
      body: Column(
        children: [
          Row(
            children: [// 영웅의 상태를 고정하는 부분
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.red[100],
                child: Column(
                  children: [
                    Text("영웅 레벨: ${_hero.level}", style: TextStyle(color: Colors.white)),
                    Text("경험치: ${_hero.currentExperience} / ${_hero.maxExperience}", style: TextStyle(color: Colors.white)),
                    Text("Gold: ${_hero.gold}", style: TextStyle(color: Colors.yellow[400])),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.blue[100],
                child: Text(formattedGameTime, style: TextStyle(color: Colors.white)),
                ),
    ],
              ),

          Expanded(
            child: Stack(
              children: [
                _monster.drawCreature(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("몬스터 체력: ${_monster.currentHealth}"),
                    ElevatedButton(
                      onPressed: _attackMonster,
                      child: Text("공격하기"),
                    ),
                  ],
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    child: _showCriticalHit
                        ? Text(
                      "치명타! ${_hero.criticalHitDamage}",
                      style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    )
                        : SizedBox.shrink(), // _showCriticalHit이 false일 때 빈 위젯 반환
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}