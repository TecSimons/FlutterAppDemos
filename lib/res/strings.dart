class Ids {
  static const String titleHome = 'title_home';
  static const String titleRepos = 'title_repos';
  static const String titleEvents = 'title_events';
  static const String titleSystem = 'title_system';


}

Map<String, Map<String, String>> localizedSimpleValues = {
  'en': {
    Ids.titleHome: 'Home',
    Ids.titleRepos: 'Repos',
    Ids.titleEvents: 'Events',
    Ids.titleSystem: 'System',

  },
  'zh': {
    Ids.titleHome: '主页',
    Ids.titleRepos: '项目',
    Ids.titleEvents: '动态',
    Ids.titleSystem: '体系',

  },
};



Map<String, Map<String, Map<String, String>>> localizedValues = {
  'en': {
    'US': {
      Ids.titleHome: 'Home',
      Ids.titleRepos: 'Repos',
      Ids.titleEvents: 'Events',
      Ids.titleSystem: 'System',

    }
  },
  'zh': {
    'CN': {
      Ids.titleHome: '主页',
      Ids.titleRepos: '项目',
      Ids.titleEvents: '动态',
      Ids.titleSystem: '体系',

    },
    'HK': {
      Ids.titleHome: '主頁',
      Ids.titleRepos: '項目',
      Ids.titleEvents: '動態',
      Ids.titleSystem: '體系',

    }
  }
};
