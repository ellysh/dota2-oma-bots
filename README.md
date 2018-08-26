# Dota 2 OMA Bots 1.0 version

*This project is still in a developing stage.*

These are Objective-Moves-Actions (OMA) bots for Dota 2.

A current development state is available in the [`CHANGELOG.md`](CHANGELOG.md) file.

## Concept

The idea of the bot is deciding on the required action on several levels. The first level is choosing an objective to reach. The second level is selecting an appropriate move to achieve the objective. Then the last step is performing actions, which compose the selected move. The bot performs the most appropriate moves until the chosen objective is not reached.

## Usage

There are steps to start playing with the bot:

1. Create a lobby.
2. Choose the "1v1 Solo Mid" game mode.
3. Choose the OMA bots for both sides.
4. Start a game.
5. Pick Drow Ranger.
6. Wait until bots do not pick their heroes after you.

You can play with OMA Bots in the "All pick" mode. In this case, Shadow Shaman bot buys a courier for you. You should stop "All pick" game when any side does two kills or mid Tier 1 Tower is destroyed.

## Limitations

You should follow the following limitations when playing with the bot:

1. Pick only Drow Ranger hero.
2. No wards.
3. No shrines.
4. No neutral camps or Roshan.
5. No bottle.
6. No scan.
7. No runes.
8. Bot difficulty is Hard or above.

## Update

Shadow Shaman bot prints the current bots version in all chat when a game starts. If you notice that the bots version is older than the actual one on the steam workshop, you should update bots. In most cases, workshop items do their update automatically but sometimes you should do it manually.

These are steps for manual updating a workshop item:

1. Unsubscribe from the workshop item from the Dota 2 client.
2. Exit from the Dota 2 and Steam.
3. Start the Steam and Dota 2.
4. Subscribe to the workshop item again.

Dota 2 client removes the workshop item from the hard drive when you unsubscribe from it. When you subscribe on it again, the item will be downloaded in the new clean directory.

## Contacts

You can ask any questions about usage of OMA Bots via email petrsum@gmail.com.

## License

This project is distributed under the GPL v3.0 license
