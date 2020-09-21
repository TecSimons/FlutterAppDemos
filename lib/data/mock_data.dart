import 'package:flutter/material.dart';
import 'package:flutter_app/Item/news_card.dart';
import 'package:flutter_app/Item/service_item.dart';
import 'package:flutter_app/pages/pet_card.dart';
import 'package:flutter_app/pages/pet_card_load.dart';



import 'custom_icons.dart';


/// 宠物卡片mock数据
 PetCardViewModel petCardData = PetCardViewModel(
	coverUrl: 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1425538345,901220022&fm=26&gp=0.jpg',
	userImgUrl: 'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1699287406,228622974&fm=26&gp=0.jpg',
	userName: '大米要煮小米粥',
	description: '小米 | 我家的小仓鼠',
	publishTime: '12:59',
	topic: '萌宠小屋',
	publishContent: '今天带着小VIVI去了爪子生活体验馆，好多好玩的小东西都想带回家！',
	replies: 356,
	likes: 258,
	shares: 126,
);



/// 美团 - 服务菜单
const List<ServiceItemViewModel> serviceList = [
	ServiceItemViewModel(
		title: '精选早餐',
		icon: Icon(
			CustomIcons.breakFirst,
			size: 25,
			color: Colors.lightBlue,
		),
	),
	ServiceItemViewModel(
		title: '包子',
		icon: Icon(
			CustomIcons.baozi,
			size: 25,
			color: Colors.orangeAccent,
		),
	),
	ServiceItemViewModel(
		title: '炸鸡',
		icon: Icon(
			CustomIcons.friedFood,
			size: 29,
			color: Colors.deepOrangeAccent,
		),
	),
	ServiceItemViewModel(
		title: '网红甜品',
		icon: Icon(
			CustomIcons.sweetmeats,
			size: 30,
			color: Colors.pinkAccent,
		),
	),
	ServiceItemViewModel(
		title: '湘菜',
		icon: Icon(
			CustomIcons.xiangCuisine,
			size: 20,
			color: Colors.redAccent,
		),
	),
	ServiceItemViewModel(
		title: '减免配送费',
		icon: Icon(
			CustomIcons.truck,
			size: 25,
			color: Colors.orange,
		),
	),
	ServiceItemViewModel(
		title: '美团专送',
		icon: Icon(
			CustomIcons.motorbike,
			size: 28,
			color: Colors.blueAccent,
		),
	),
	ServiceItemViewModel(
		title: '到点自取',
		icon: Icon(
			CustomIcons.shop,
			size: 25,
			color: Colors.lightGreen,
		),
	),
	ServiceItemViewModel(
		title: '跑腿代购',
		icon: Icon(
			CustomIcons.errand,
			size: 25,
			color: Colors.red,
		),
	),
	ServiceItemViewModel(
		title: '全部分类',
		icon: Icon(
			CustomIcons.allCategories,
			size: 25,
			color: Colors.amber,
		),
	),
];


const List<NewsViewModel> newsList = [
	NewsViewModel(
		title: '中方将派军舰赴马六甲海峡护航本国船只？外交部：那是谣言',
		source: '环球网',
		comments: 71,
		coverImgUrl: 'https://p3.pstatp.com/list/190x124/pgc-image/RGSD09itseweQ',
	),
	NewsViewModel(
		title: '211高校被误认野鸡大学发怒，名气还没“野鸡”大',
		source: '中国新闻周刊',
		comments: 980,
		coverImgUrl: 'https://p1.pstatp.com/list/190x124/pgc-image/7026a3edfe2b47f59eea94f2b8cd86a4',
	),
	NewsViewModel(
		title: '广西矿王黎东明去世：瞒报81死矿难，把记者逼到悬崖边，遭售货员白眼后买下整柜台皮鞋',
		source: '大河看法',
		comments: 2759,
		coverImgUrl: 'https://p1.pstatp.com/list/190x124/pgc-image/c14366a3b7ab4a3384e3485697d103fe',
	),
	NewsViewModel(
		title: '六旬父亲“为儿追凶”16年：“赔多少钱都不要，就要他偿命”',
		source: '中国新闻周刊',
		comments: 20645,
		coverImgUrl: 'https://p3.pstatp.com/list/190x124/pgc-image/c55f17d3a3ac4efe8eaedafdab111079',
	),
	NewsViewModel(
		title: '五问玛莎拉蒂追尾案：肇事女孩有何背景？或面临死刑？',
		source: '环球网',
		comments: 2121,
		coverImgUrl: 'https://p1.pstatp.com/list/190x124/pgc-image/RVi866A4f9cVK2',
	),
	NewsViewModel(
		title: '李若彤：当年为爱作出任性选择，如今看来都是最好的安排',
		source: '新京报',
		comments: 243,
		coverImgUrl: 'https://p3.pstatp.com/list/190x124/pgc-image/RVLwKBq5IQMvCW',
	),
	NewsViewModel(
			title: '好惨一首都！“史诗级”暴雨把华盛顿淹成了……这个样子',
			source: '环球网',
			comments: 750,
			coverImgUrl: 'https://p1.pstatp.com/list/190x124/pgc-image/RVic5NyDDeVAi0'
	),
	NewsViewModel(
			title: '原子弹爆炸半衰期动不动几万年，为何广岛和长崎现在就能居住了？',
			source: '怪罗科普',
			comments: 325,
			coverImgUrl: 'https://p1.pstatp.com/list/190x124/pgc-image/317a92302937426c999ea9a5b52121b1'
	),
	NewsViewModel(
			title: '马超和关羽到底谁强？古书记载颠覆历史，学者：根本不是一个级别',
			source: '田君良',
			comments: 856,
			coverImgUrl: 'https://p3.pstatp.com/list/190x124/pgc-image/470fb21c5c884b119116179813b82d2b'
	),NewsViewModel(
			title: '马超和关羽到底谁强？古书记载颠覆历史，学者：根本不是一个级别',
			source: '田君良',
			comments: 856,
			coverImgUrl: 'https://p3.pstatp.com/list/190x124/pgc-image/470fb21c5c884b119116179813b82d2b'
	),
];