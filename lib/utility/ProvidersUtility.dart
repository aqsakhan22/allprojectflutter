import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwith/providers/chat_provider.dart';
import 'package:runwith/providers/clubs_provider.dart';
import 'package:runwith/providers/running_buddies.dart';
import '../providers/audioqueues_provider.dart';
import '../providers/quotes_provider.dart';
import '../providers/socila_feeds_provider.dart';
import 'top_level_variables.dart';

class ProvidersUtility{
  static BuildContext? providersContext = TopVariables.appNavigationKey.currentContext;
  static SocialfeedsProvider? socialProvider = Provider.of<SocialfeedsProvider>(providersContext!, listen: false);
  static ChatProvider? chatsProvider = Provider.of<ChatProvider>(providersContext!, listen: false);
  static ClubsProvider? clubProvider = Provider.of<ClubsProvider>(providersContext!, listen: false);
  static RunningBuddiesProvider? buddiesProvider = Provider.of<RunningBuddiesProvider>(providersContext!, listen: false);
  static QuoteProvider? quoteProvider = Provider.of<QuoteProvider>(providersContext!, listen: false);
  static AudioQueuesProvider? audioQueuesProvider = Provider.of<AudioQueuesProvider>(providersContext!, listen: false);
}