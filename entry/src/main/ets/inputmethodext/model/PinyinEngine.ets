/**
 * Pinyin-to-Chinese character conversion engine.
 * Maps pinyin syllables (without tones) to frequently-used Chinese characters.
 */
export class PinyinEngine {
  // Pinyin -> Chinese characters, ordered by frequency
  private static pinyinDict: Map<string, string[]> = new Map([
    ['a', ['啊', '阿', '吖']],
    ['ai', ['爱', '艾', '哎', '哀', '挨', '矮', '碍', '癌']],
    ['an', ['安', '按', '案', '暗', '岸', '俺', '鞍', '氨']],
    ['ang', ['昂', '肮']],
    ['ao', ['奥', '傲', '凹', '熬', '袄']],
    ['ba', ['把', '吧', '八', '巴', '爸', '拔', '霸', '罢', '坝']],
    ['bai', ['百', '白', '败', '拜', '摆', '柏', '佰']],
    ['ban', ['办', '半', '版', '班', '般', '板', '搬', '扮', '伴', '瓣']],
    ['bang', ['帮', '邦', '绑', '榜', '傍', '棒', '磅']],
    ['bao', ['报', '包', '保', '宝', '抱', '暴', '薄', '爆', '胞', '饱']],
    ['bei', ['被', '北', '备', '背', '杯', '辈', '悲', '碑', '贝', '倍']],
    ['ben', ['本', '奔', '笨']],
    ['beng', ['蹦', '崩', '泵', '绷']],
    ['bi', ['比', '必', '笔', '闭', '逼', '币', '避', '壁', '毕', '臂', '碧', '鼻']],
    ['bian', ['变', '便', '边', '编', '辩', '遍', '辨', '鞭', '扁']],
    ['biao', ['表', '标', '彪', '飙']],
    ['bie', ['别', '憋']],
    ['bin', ['宾', '斌', '滨', '彬', '濒']],
    ['bing', ['并', '病', '兵', '冰', '饼', '丙', '柄', '秉']],
    ['bo', ['波', '博', '薄', '播', '拨', '伯', '驳', '玻', '脖']],
    ['bu', ['不', '部', '步', '布', '补', '捕', '簿', '埠']],
    ['ca', ['擦']],
    ['cai', ['才', '材', '财', '采', '彩', '菜', '猜', '裁']],
    ['can', ['参', '餐', '残', '惨', '灿', '惭']],
    ['cang', ['藏', '仓', '苍', '舱']],
    ['cao', ['操', '草', '曹', '槽']],
    ['ce', ['策', '测', '侧', '册', '厕']],
    ['cen', ['参', '岑']],
    ['ceng', ['曾', '层', '蹭']],
    ['cha', ['查', '差', '茶', '察', '插', '叉', '刹']],
    ['chai', ['差', '拆', '柴', '豺']],
    ['chan', ['产', '缠', '铲', '阐', '颤', '掺', '蝉']],
    ['chang', ['长', '场', '厂', '常', '唱', '昌', '畅', '倡', '偿', '肠']],
    ['chao', ['超', '朝', '潮', '炒', '抄', '吵', '巢']],
    ['che', ['车', '彻', '撤', '扯', '澈']],
    ['chen', ['陈', '沉', '晨', '臣', '衬', '趁', '称', '辰', '尘']],
    ['cheng', ['成', '城', '程', '称', '承', '诚', '呈', '乘', '惩', '撑', '澄']],
    ['chi', ['吃', '持', '尺', '迟', '池', '赤', '驰', '耻', '翅', '齿']],
    ['chong', ['重', '充', '冲', '崇', '虫', '宠']],
    ['chou', ['抽', '愁', '筹', '仇', '丑', '臭', '酬', '绸']],
    ['chu', ['出', '处', '初', '除', '楚', '础', '触', '储', '畜', '厨']],
    ['chuai', ['揣', '踹']],
    ['chuan', ['传', '穿', '船', '川', '串', '喘']],
    ['chuang', ['创', '窗', '床', '闯', '疮']],
    ['chui', ['吹', '垂', '锤', '炊']],
    ['chun', ['春', '纯', '唇', '醇', '蠢']],
    ['chuo', ['绰', '戳']],
    ['ci', ['此', '次', '词', '辞', '刺', '磁', '慈', '瓷']],
    ['cong', ['从', '聪', '丛', '匆', '葱']],
    ['cou', ['凑']],
    ['cu', ['促', '粗', '醋', '簇']],
    ['cuan', ['窜', '篡', '攒']],
    ['cui', ['催', '脆', '翠', '崔', '粹', '摧']],
    ['cun', ['村', '存', '寸']],
    ['cuo', ['错', '措', '挫', '磋']],
    ['da', ['大', '打', '达', '答', '搭']],
    ['dai', ['大', '代', '带', '待', '戴', '袋', '贷', '逮', '怠']],
    ['dan', ['但', '单', '蛋', '担', '弹', '淡', '胆', '旦', '诞', '丹']],
    ['dang', ['当', '党', '档', '荡', '挡']],
    ['dao', ['到', '道', '导', '倒', '岛', '刀', '盗', '稻', '悼']],
    ['de', ['的', '德', '得']],
    ['dei', ['得']],
    ['den', ['扽']],
    ['deng', ['等', '登', '灯', '邓', '瞪', '凳']],
    ['di', ['地', '第', '低', '底', '敌', '弟', '递', '帝', '滴', '抵', '迪', '笛']],
    ['dia', ['嗲']],
    ['dian', ['点', '电', '店', '典', '垫', '殿', '碘', '甸', '颠', '奠']],
    ['diao', ['调', '掉', '雕', '吊', '钓', '刁']],
    ['die', ['跌', '叠', '爹', '碟', '蝶', '迭']],
    ['ding', ['定', '顶', '订', '丁', '鼎', '盯', '钉', '锭']],
    ['diu', ['丢']],
    ['dong', ['动', '东', '冬', '懂', '洞', '董', '栋', '冻']],
    ['dou', ['都', '斗', '豆', '抖', '逗', '兜', '陡', '窦']],
    ['du', ['都', '度', '读', '独', '堵', '杜', '肚', '毒', '督', '赌', '渡', '镀']],
    ['duan', ['段', '断', '短', '端', '锻', '缎']],
    ['dui', ['对', '队', '堆', '兑', '敦']],
    ['dun', ['吨', '顿', '蹲', '盾', '敦', '钝']],
    ['duo', ['多', '夺', '朵', '躲', '堕', '舵', '惰']],
    ['e', ['额', '俄', '恶', '饿', '鹅', '扼', '厄', '鄂']],
    ['en', ['嗯', '恩']],
    ['er', ['而', '二', '儿', '尔', '耳']],
    ['fa', ['发', '法', '罚', '伐', '阀', '乏', '筏']],
    ['fan', ['反', '饭', '范', '翻', '犯', '繁', '凡', '泛', '帆', '番']],
    ['fang', ['方', '放', '房', '防', '访', '仿', '纺', '芳', '妨', '坊']],
    ['fei', ['非', '飞', '费', '肥', '废', '菲', '匪', '肺', '沸']],
    ['fen', ['分', '份', '粉', '纷', '芬', '奋', '愤', '坟', '氛', '焚']],
    ['feng', ['风', '封', '峰', '丰', '奉', '凤', '锋', '疯', '逢', '缝', '冯']],
    ['fo', ['佛']],
    ['fou', ['否']],
    ['fu', ['服', '副', '复', '福', '府', '附', '负', '富', '父', '夫', '妇', '幅', '扶', '符', '腐', '浮', '抚', '覆', '赴', '伏', '辅', '赋', '傅', '腹', '俘']],
    ['ga', ['嘎', '咖']],
    ['gai', ['改', '该', '盖', '概', '钙']],
    ['gan', ['感', '干', '赶', '敢', '甘', '杆', '肝', '竿', '尴', '秆']],
    ['gang', ['刚', '港', '钢', '岗', '纲', '缸', '杠']],
    ['gao', ['高', '告', '搞', '稿', '糕', '膏']],
    ['ge', ['个', '各', '歌', '格', '哥', '革', '隔', '阁', '戈', '鸽', '搁']],
    ['gei', ['给']],
    ['gen', ['跟', '根']],
    ['geng', ['更', '耕', '庚', '耿', '羹', '梗']],
    ['gong', ['工', '公', '功', '共', '供', '攻', '宫', '巩', '贡', '恭', '弓', '躬']],
    ['gou', ['够', '狗', '购', '构', '沟', '勾', '苟', '钩']],
    ['gu', ['故', '古', '股', '顾', '鼓', '骨', '谷', '固', '孤', '估', '姑', '雇']],
    ['gua', ['挂', '瓜', '刮', '寡', '卦']],
    ['guai', ['怪', '拐', '乖']],
    ['guan', ['关', '管', '官', '观', '馆', '惯', '冠', '罐', '灌', '贯']],
    ['guang', ['光', '广', '逛']],
    ['gui', ['规', '归', '贵', '鬼', '桂', '柜', '轨', '跪', '龟', '硅', '瑰']],
    ['gun', ['滚', '棍']],
    ['guo', ['过', '国', '果', '郭', '锅', '裹']],
    ['ha', ['哈']],
    ['hai', ['还', '海', '孩', '害', '亥', '骇']],
    ['han', ['汉', '含', '喊', '寒', '韩', '函', '罕', '旱', '焊', '汗', '憾', '涵']],
    ['hang', ['行', '航', '杭']],
    ['hao', ['好', '号', '毫', '豪', '耗', '浩', '皓']],
    ['he', ['和', '合', '河', '何', '核', '喝', '贺', '荷', '赫', '鹤']],
    ['hei', ['黑', '嘿']],
    ['hen', ['很', '恨', '狠', '痕']],
    ['heng', ['横', '恒', '衡', '哼']],
    ['hong', ['红', '宏', '洪', '鸿', '虹', '轰', '弘']],
    ['hou', ['后', '候', '厚', '侯', '喉', '猴', '吼']],
    ['hu', ['湖', '互', '护', '户', '虎', '呼', '忽', '胡', '壶', '弧', '糊']],
    ['hua', ['化', '话', '花', '华', '画', '划', '滑', '桦']],
    ['huai', ['坏', '怀', '淮', '徊']],
    ['huan', ['还', '环', '换', '欢', '患', '缓', '唤', '幻', '焕', '宦']],
    ['huang', ['黄', '皇', '慌', '煌', '晃', '荒', '凰', '簧', '谎']],
    ['hui', ['会', '回', '辉', '惠', '汇', '慧', '绘', '毁', '灰', '恢', '挥', '徽', '贿', '晦']],
    ['hun', ['混', '婚', '魂', '昏', '浑']],
    ['huo', ['活', '火', '或', '货', '获', '霍', '伙', '惑', '祸', '豁']],
    ['ji', ['机', '几', '计', '记', '及', '即', '极', '集', '际', '技', '基', '济', '纪', '季', '既', '级', '击', '积', '激', '吉', '急', '继', '迹', '剂', '鸡', '疾', '绩', '祭', '籍', '辑', '寂', '忌', '肌', '讥', '饥', '姬']],
    ['jia', ['家', '加', '价', '假', '佳', '架', '甲', '嘉', '驾', '嫁', '夹', '颊']],
    ['jian', ['见', '间', '件', '建', '健', '简', '检', '减', '渐', '坚', '剑', '肩', '践', '鉴', '键', '尖', '兼', '煎', '监', '艰', '箭', '拣', '捡', '俭', '柬', '荐', '贱', '溅', '舰']],
    ['jiang', ['将', '江', '讲', '降', '奖', '疆', '蒋', '姜', '浆', '匠', '僵', '酱']],
    ['jiao', ['教', '交', '较', '叫', '角', '脚', '焦', '浇', '郊', '骄', '娇', '搅', '轿', '缴', '绞', '椒', '矫']],
    ['jie', ['解', '接', '界', '结', '街', '节', '介', '姐', '戒', '届', '阶', '借', '揭', '杰', '洁', '截', '竭', '劫', '桔']],
    ['jin', ['进', '今', '金', '近', '仅', '尽', '紧', '禁', '劲', '锦', '津', '谨', '筋', '巾', '浸', '晋']],
    ['jing', ['经', '京', '精', '景', '静', '境', '竟', '警', '镜', '敬', '净', '竞', '睛', '径', '井', '晶', '颈', '靖']],
    ['jiong', ['窘', '炯', '迥']],
    ['jiu', ['就', '九', '酒', '久', '旧', '救', '究', '纠', '舅', '灸', '韭', '臼']],
    ['ju', ['据', '具', '局', '剧', '举', '居', '距', '聚', '巨', '句', '拒', '俱', '菊', '矩', '鞠', '锯', '惧', '驹']],
    ['juan', ['卷', '捐', '绢', '倦', '鹃']],
    ['jue', ['决', '觉', '绝', '掘', '爵', '崛', '诀', '倔']],
    ['jun', ['均', '军', '君', '俊', '峻', '菌', '骏', '竣']],
    ['ka', ['卡', '咖', '喀']],
    ['kai', ['开', '凯', '慨', '楷', '铠']],
    ['kan', ['看', '刊', '砍', '堪', '勘']],
    ['kang', ['抗', '康', '扛', '慷', '炕']],
    ['kao', ['考', '靠', '烤', '拷']],
    ['ke', ['可', '科', '课', '客', '刻', '颗', '棵', '壳', '渴', '克', '柯', '咳', '磕', '苛']],
    ['ken', ['肯', '恳', '垦', '啃']],
    ['keng', ['坑', '吭']],
    ['kong', ['空', '孔', '控', '恐']],
    ['kou', ['口', '扣', '寇', '叩', '抠']],
    ['ku', ['苦', '哭', '库', '裤', '酷', '窟']],
    ['kua', ['跨', '夸', '垮', '挎']],
    ['kuai', ['快', '块', '筷', '会']],
    ['kuan', ['款', '宽']],
    ['kuang', ['况', '矿', '框', '狂', '旷', '筐', '眶']],
    ['kui', ['亏', '葵', '愧', '魁', '溃', '窥']],
    ['kun', ['困', '昆', '捆', '坤']],
    ['kuo', ['扩', '括', '阔', '廓']],
    ['la', ['拉', '啦', '辣', '蜡', '腊', '喇']],
    ['lai', ['来', '赖', '莱', '癞']],
    ['lan', ['蓝', '兰', '栏', '览', '烂', '篮', '拦', '懒', '缆', '澜', '滥']],
    ['lang', ['浪', '朗', '狼', '郎', '廊']],
    ['lao', ['老', '劳', '牢', '捞', '姥', '涝', '烙']],
    ['le', ['了', '乐', '勒']],
    ['lei', ['累', '类', '雷', '泪', '蕾', '肋', '擂', '磊']],
    ['leng', ['冷', '楞', '棱']],
    ['li', ['里', '理', '力', '利', '立', '例', '离', '历', '李', '丽', '礼', '励', '粒', '厉', '梨', '黎', '隶', '璃', '莉', '狸']],
    ['lia', ['俩']],
    ['lian', ['联', '连', '练', '脸', '恋', '链', '莲', '廉', '帘', '怜', '炼']],
    ['liang', ['两', '量', '亮', '良', '梁', '粮', '凉', '辆', '谅']],
    ['liao', ['了', '料', '聊', '疗', '辽', '僚', '缭', '寥']],
    ['lie', ['列', '烈', '裂', '猎', '劣']],
    ['lin', ['林', '临', '邻', '淋', '琳', '磷', '鳞', '凛']],
    ['ling', ['领', '令', '零', '另', '灵', '岭', '凌', '铃', '陵', '龄']],
    ['liu', ['流', '六', '留', '刘', '柳', '溜', '瘤', '硫']],
    ['long', ['龙', '隆', '笼', '聋', '拢', '珑']],
    ['lou', ['楼', '漏', '露', '搂', '陋']],
    ['lu', ['路', '录', '陆', '露', '鲁', '炉', '鹿', '芦', '卢', '碌', '禄', '颅']],
    ['lv', ['绿', '旅', '率', '律', '铝', '虑', '吕', '氯', '滤']],
    ['luan', ['乱', '卵']],
    ['lue', ['略', '掠']],
    ['lun', ['论', '轮', '伦', '沦', '纶']],
    ['luo', ['落', '罗', '络', '洛', '骆', '裸', '逻', '锣']],
    ['ma', ['吗', '马', '妈', '麻', '码', '骂', '玛', '蚂']],
    ['mai', ['买', '卖', '麦', '脉', '埋']],
    ['man', ['满', '慢', '漫', '曼', '蛮', '埋', '蔓', '馒', '瞒']],
    ['mang', ['忙', '盲', '芒', '茫', '氓']],
    ['mao', ['毛', '猫', '冒', '帽', '贸', '矛', '茅', '貌', '茂']],
    ['me', ['么']],
    ['mei', ['没', '美', '每', '妹', '梅', '媒', '煤', '眉', '玫', '酶', '霉']],
    ['men', ['们', '门', '闷']],
    ['meng', ['梦', '蒙', '猛', '盟', '孟', '萌', '锰']],
    ['mi', ['密', '米', '迷', '秘', '蜜', '谜', '弥', '泌']],
    ['mian', ['面', '免', '棉', '绵', '眠', '缅']],
    ['miao', ['秒', '妙', '庙', '描', '苗', '瞄']],
    ['mie', ['灭', '蔑']],
    ['min', ['民', '敏', '闽', '皿']],
    ['ming', ['名', '明', '命', '鸣', '铭']],
    ['miu', ['谬', '缪']],
    ['mo', ['模', '末', '莫', '默', '磨', '墨', '摩', '膜', '沫', '漠', '陌']],
    ['mou', ['某', '谋', '牟']],
    ['mu', ['目', '母', '木', '亩', '幕', '牧', '墓', '慕', '穆', '暮', '沐']],
    ['na', ['那', '拿', '哪', '纳', '娜', '呐']],
    ['nai', ['奶', '耐', '奈', '乃']],
    ['nan', ['男', '南', '难']],
    ['nang', ['囊']],
    ['nao', ['脑', '闹', '恼', '挠']],
    ['ne', ['呢']],
    ['nei', ['内', '馁']],
    ['nen', ['嫩']],
    ['neng', ['能']],
    ['ni', ['你', '尼', '泥', '逆', '拟', '腻', '妮']],
    ['nian', ['年', '念', '碾', '粘']],
    ['niang', ['娘', '酿']],
    ['niao', ['鸟', '尿']],
    ['nie', ['捏', '聂', '镍', '涅']],
    ['nin', ['您']],
    ['ning', ['宁', '凝', '拧']],
    ['niu', ['牛', '纽', '扭', '钮']],
    ['nong', ['农', '弄', '浓']],
    ['nu', ['努', '怒', '奴']],
    ['nv', ['女']],
    ['nuan', ['暖']],
    ['nue', ['虐', '疟']],
    ['nuo', ['诺', '挪', '懦']],
    ['o', ['哦']],
    ['ou', ['欧', '偶', '殴', '呕', '藕']],
    ['pa', ['怕', '爬', '帕', '趴']],
    ['pai', ['排', '派', '牌', '拍', '徘']],
    ['pan', ['判', '盘', '盼', '叛', '攀', '畔', '潘']],
    ['pang', ['旁', '胖', '庞', '乓']],
    ['pao', ['跑', '炮', '泡', '抛', '袍']],
    ['pei', ['配', '培', '赔', '陪', '佩', '沛', '裴']],
    ['pen', ['喷', '盆']],
    ['peng', ['朋', '碰', '棚', '捧', '膨', '鹏', '蓬', '彭', '硼']],
    ['pi', ['批', '皮', '匹', '辟', '劈', '啤', '脾', '疲']],
    ['pian', ['片', '篇', '偏', '骗', '翩']],
    ['piao', ['票', '飘', '漂', '瓢']],
    ['pie', ['撇', '瞥']],
    ['pin', ['品', '贫', '拼', '频', '聘']],
    ['ping', ['平', '评', '瓶', '凭', '萍', '屏', '苹', '坪']],
    ['po', ['破', '迫', '颇', '坡', '泼', '婆', '珀']],
    ['pou', ['剖']],
    ['pu', ['普', '铺', '朴', '扑', '谱', '葡', '蒲', '仆']],
    ['qi', ['其', '起', '气', '七', '期', '器', '企', '齐', '奇', '汽', '启', '旗', '妻', '弃', '祈', '漆', '骑', '棋', '泣', '岐', '祁', '凄']],
    ['qia', ['恰', '洽', '掐']],
    ['qian', ['前', '钱', '千', '签', '潜', '浅', '欠', '迁', '铅', '谦', '嵌', '乾', '遣', '歉', '黔']],
    ['qiang', ['强', '墙', '枪', '抢', '腔', '蔷']],
    ['qiao', ['桥', '巧', '敲', '瞧', '乔', '俏', '翘', '侨', '窍', '峭']],
    ['qie', ['且', '切', '窃', '茄']],
    ['qin', ['亲', '琴', '侵', '勤', '秦', '寝', '芹', '禽', '钦']],
    ['qing', ['情', '清', '请', '青', '庆', '轻', '晴', '倾', '氢', '卿']],
    ['qiong', ['穷', '琼']],
    ['qiu', ['求', '球', '秋', '丘', '邱', '囚', '酋']],
    ['qu', ['去', '区', '取', '曲', '趣', '渠', '驱', '屈', '趋', '娶']],
    ['quan', ['全', '权', '券', '泉', '拳', '圈', '劝', '犬']],
    ['que', ['却', '确', '缺', '雀', '鹊']],
    ['qun', ['群', '裙']],
    ['ran', ['然', '染', '燃', '冉']],
    ['rang', ['让', '壤', '嚷']],
    ['rao', ['绕', '扰', '饶']],
    ['re', ['热', '惹']],
    ['ren', ['人', '任', '认', '忍', '仁', '刃', '韧']],
    ['reng', ['仍', '扔']],
    ['ri', ['日']],
    ['rong', ['容', '融', '荣', '蓉', '溶', '绒', '冗', '熔']],
    ['rou', ['肉', '柔', '揉']],
    ['ru', ['如', '入', '儒', '乳', '汝', '辱']],
    ['ruan', ['软', '阮']],
    ['rui', ['瑞', '锐', '睿']],
    ['run', ['润', '闰']],
    ['ruo', ['若', '弱']],
    ['sa', ['洒', '撒', '萨']],
    ['sai', ['赛', '塞', '腮']],
    ['san', ['三', '散', '伞', '叁']],
    ['sang', ['桑', '嗓', '丧']],
    ['sao', ['扫', '嫂', '骚']],
    ['se', ['色', '涩', '瑟', '塞']],
    ['sen', ['森']],
    ['seng', ['僧']],
    ['sha', ['杀', '沙', '纱', '砂', '傻', '刹', '鲨']],
    ['shai', ['晒', '筛']],
    ['shan', ['山', '善', '闪', '衫', '扇', '删', '珊', '陕', '擅', '膳']],
    ['shang', ['上', '商', '伤', '尚', '赏', '裳']],
    ['shao', ['少', '绍', '烧', '稍', '勺', '哨', '邵']],
    ['she', ['社', '设', '射', '涉', '蛇', '舍', '舌', '摄', '奢']],
    ['shei', ['谁']],
    ['shen', ['什', '深', '身', '神', '审', '甚', '伸', '沈', '慎', '渗', '肾', '申']],
    ['sheng', ['生', '声', '升', '省', '胜', '圣', '盛', '剩', '牲', '绳']],
    ['shi', ['是', '时', '十', '事', '实', '使', '世', '市', '式', '识', '示', '石', '师', '士', '史', '始', '势', '适', '施', '失', '试', '室', '食', '似', '诗', '湿', '释', '氏', '视', '驶', '尸', '饰', '誓', '拾']],
    ['shou', ['手', '受', '首', '收', '守', '授', '寿', '售', '兽', '瘦']],
    ['shu', ['书', '数', '术', '树', '属', '输', '述', '束', '舒', '熟', '鼠', '叔', '署', '蔬', '殊', '抒', '淑', '竖', '薯', '暑']],
    ['shua', ['刷', '耍']],
    ['shuai', ['率', '摔', '帅', '衰', '甩']],
    ['shuan', ['栓', '拴', '涮']],
    ['shuang', ['双', '爽', '霜']],
    ['shui', ['水', '谁', '睡', '税']],
    ['shun', ['顺', '瞬', '舜']],
    ['shuo', ['说', '硕', '烁']],
    ['si', ['四', '思', '死', '司', '丝', '私', '寺', '似', '肆', '饲', '撕', '嗣', '嘶']],
    ['song', ['送', '松', '宋', '颂', '耸', '诵']],
    ['sou', ['搜', '艘', '嗽']],
    ['su', ['速', '素', '苏', '诉', '塑', '宿', '肃', '俗', '粟', '溯', '酥']],
    ['suan', ['算', '酸', '蒜']],
    ['sui', ['虽', '随', '岁', '碎', '遂', '穗', '隋']],
    ['sun', ['损', '孙', '笋']],
    ['suo', ['所', '索', '锁', '缩', '梭', '琐']],
    ['ta', ['他', '她', '它', '塔', '踏', '塌', '榻']],
    ['tai', ['太', '台', '态', '泰', '抬', '胎', '汰', '苔']],
    ['tan', ['谈', '弹', '坦', '探', '碳', '叹', '滩', '摊', '潭', '痰', '贪', '毯']],
    ['tang', ['堂', '唐', '躺', '糖', '汤', '趟', '塘', '烫', '棠']],
    ['tao', ['套', '讨', '逃', '桃', '淘', '陶', '涛', '萄']],
    ['te', ['特']],
    ['tei', ['忒']],
    ['teng', ['疼', '腾', '藤']],
    ['ti', ['提', '题', '体', '替', '梯', '踢', '剔', '蹄', '啼']],
    ['tian', ['天', '田', '填', '甜', '添', '恬']],
    ['tiao', ['条', '调', '跳', '挑', '眺']],
    ['tie', ['铁', '贴', '帖']],
    ['ting', ['听', '停', '庭', '厅', '廷', '亭', '挺', '艇']],
    ['tong', ['同', '通', '统', '痛', '铜', '童', '桶', '筒', '彤']],
    ['tou', ['头', '投', '透', '偷']],
    ['tu', ['图', '土', '突', '途', '涂', '兔', '吐', '徒', '屠']],
    ['tuan', ['团']],
    ['tui', ['推', '退', '腿', '褪', '颓']],
    ['tun', ['吞', '屯', '臀']],
    ['tuo', ['脱', '托', '拖', '妥', '拓', '驼', '椭']],
    ['wa', ['瓦', '挖', '蛙', '娃', '袜', '洼']],
    ['wai', ['外', '歪']],
    ['wan', ['万', '完', '晚', '玩', '湾', '碗', '弯', '挽', '丸', '顽', '婉', '腕']],
    ['wang', ['王', '往', '网', '望', '忘', '亡', '汪', '旺', '枉']],
    ['wei', ['为', '位', '未', '维', '味', '围', '微', '卫', '委', '伟', '威', '唯', '谓', '慰', '违', '尾', '危', '魏', '伪', '畏', '喂', '纬', '蔚', '胃', '萎', '韦']],
    ['wen', ['文', '问', '温', '闻', '稳', '纹', '蚊', '吻']],
    ['weng', ['翁', '嗡', '瓮']],
    ['wo', ['我', '握', '沃', '卧', '窝', '涡']],
    ['wu', ['无', '五', '物', '务', '武', '误', '舞', '屋', '乌', '吴', '午', '悟', '雾', '伍', '污', '勿', '巫', '吾', '侮', '坞']],
    ['xi', ['西', '系', '细', '习', '席', '吸', '息', '希', '析', '喜', '戏', '洗', '稀', '锡', '溪', '悉', '惜', '袭', '熄', '膝', '夕', '牺', '媳']],
    ['xia', ['下', '夏', '峡', '吓', '虾', '狭', '霞', '暇', '辖', '侠']],
    ['xian', ['现', '先', '线', '显', '限', '险', '献', '鲜', '县', '闲', '仙', '宪', '陷', '纤', '掀', '贤', '咸', '衔', '嫌', '羡']],
    ['xiang', ['想', '向', '象', '相', '香', '响', '项', '箱', '乡', '享', '详', '祥', '巷', '厢', '橡', '湘', '襄', '镶']],
    ['xiao', ['小', '消', '效', '笑', '校', '晓', '销', '肖', '孝', '削', '萧', '硝', '潇', '啸', '宵']],
    ['xie', ['些', '写', '协', '谢', '鞋', '械', '斜', '携', '泄', '卸', '谐', '邪', '蟹', '屑', '泻', '挟']],
    ['xin', ['新', '心', '信', '芯', '辛', '欣', '薪', '锌', '馨']],
    ['xing', ['行', '性', '星', '兴', '型', '形', '醒', '姓', '幸', '刑', '杏']],
    ['xiong', ['雄', '兄', '胸', '凶', '熊', '匈']],
    ['xiu', ['修', '秀', '休', '袖', '锈', '羞', '嗅', '朽']],
    ['xu', ['需', '许', '续', '序', '绪', '虚', '须', '徐', '蓄', '畜', '叙', '旭', '絮', '酗']],
    ['xuan', ['选', '宣', '悬', '旋', '玄', '轩', '喧', '炫']],
    ['xue', ['学', '血', '雪', '穴', '削', '靴', '薛']],
    ['xun', ['迅', '询', '训', '寻', '巡', '循', '讯', '旬', '熏', '勋']],
    ['ya', ['压', '亚', '牙', '雅', '呀', '押', '鸦', '鸭', '崖', '芽', '哑']],
    ['yan', ['眼', '言', '研', '验', '延', '演', '严', '烟', '沿', '盐', '岩', '颜', '炎', '厌', '宴', '掩', '艳', '雁', '燕', '焰']],
    ['yang', ['样', '阳', '养', '洋', '扬', '央', '仰', '痒', '杨', '氧', '殃', '羊', '秧', '漾', '鸯']],
    ['yao', ['要', '药', '摇', '腰', '咬', '耀', '遥', '姚', '窑', '谣', '邀']],
    ['ye', ['也', '业', '夜', '叶', '页', '液', '野', '爷', '耶', '冶']],
    ['yi', ['一', '以', '已', '意', '义', '议', '易', '衣', '艺', '益', '异', '移', '依', '疑', '仪', '忆', '宜', '遗', '翼', '译', '役', '毅', '抑', '疫', '逸', '伊', '矣']],
    ['yin', ['因', '引', '银', '印', '音', '饮', '隐', '阴', '姻', '吟', '瘾', '殷']],
    ['ying', ['应', '影', '英', '营', '迎', '映', '赢', '硬', '颖', '蝇', '盈', '樱', '鹰', '莹']],
    ['yo', ['哟']],
    ['yong', ['用', '永', '勇', '拥', '涌', '泳', '庸', '咏', '踊']],
    ['you', ['有', '又', '由', '游', '油', '友', '右', '优', '尤', '幼', '犹', '邮', '幽', '悠', '诱', '忧', '铀']],
    ['yu', ['于', '与', '育', '语', '遇', '预', '雨', '玉', '域', '余', '鱼', '愈', '欲', '渔', '宇', '誉', '预', '浴', '裕', '寓', '御', '郁', '禹', '吁']],
    ['yuan', ['元', '原', '园', '员', '远', '院', '愿', '源', '圆', '缘', '援', '怨', '冤', '渊', '苑', '猿']],
    ['yue', ['月', '约', '越', '阅', '乐', '跃', '悦', '岳', '粤']],
    ['yun', ['运', '云', '允', '韵', '孕', '晕', '蕴', '酝']],
    ['za', ['杂', '砸', '咋']],
    ['zai', ['在', '再', '载', '灾', '宰', '栽', '哉']],
    ['zan', ['咱', '赞', '暂', '攒', '簪']],
    ['zang', ['藏', '脏', '葬']],
    ['zao', ['早', '造', '遭', '糟', '噪', '灶', '澡', '枣', '躁', '藻']],
    ['ze', ['则', '责', '择', '泽', '咋']],
    ['zei', ['贼']],
    ['zen', ['怎']],
    ['zeng', ['增', '曾', '赠', '憎']],
    ['zha', ['扎', '炸', '渣', '闸', '诈', '轧', '栅', '眨']],
    ['zhai', ['摘', '宅', '窄', '债', '寨']],
    ['zhan', ['站', '战', '展', '占', '粘', '沾', '盏', '斩', '崭', '辗']],
    ['zhang', ['长', '张', '章', '掌', '障', '帐', '仗', '丈', '涨', '账', '彰', '樟']],
    ['zhao', ['找', '照', '招', '赵', '罩', '兆', '召', '朝']],
    ['zhe', ['这', '者', '折', '哲', '浙', '遮', '蔗', '辙']],
    ['zhen', ['真', '阵', '镇', '针', '震', '诊', '振', '贞', '珍', '枕', '甄', '斟']],
    ['zheng', ['正', '整', '证', '政', '争', '征', '挣', '蒸', '症', '郑', '睁', '筝']],
    ['zhi', ['只', '之', '知', '制', '指', '直', '至', '治', '志', '质', '支', '值', '职', '纸', '止', '致', '植', '殖', '织', '址', '智', '置', '枝', '芝', '旨', '滞']],
    ['zhong', ['中', '重', '种', '终', '众', '钟', '忠', '肿', '仲', '衷', '盅']],
    ['zhou', ['周', '洲', '州', '粥', '轴', '皱', '骤', '舟', '宙']],
    ['zhu', ['主', '注', '住', '助', '著', '逐', '柱', '筑', '祝', '竹', '朱', '珠', '煮', '驻', '猪', '诸', '蛛', '嘱', '烛', '铸', '株']],
    ['zhua', ['抓', '爪']],
    ['zhuai', ['拽']],
    ['zhuan', ['转', '专', '砖', '赚', '撰']],
    ['zhuang', ['装', '状', '庄', '撞', '壮', '桩', '妆']],
    ['zhui', ['追', '坠', '缀', '锥']],
    ['zhun', ['准']],
    ['zhuo', ['桌', '着', '捉', '琢', '卓', '灼', '拙', '酌']],
    ['zi', ['子', '自', '字', '资', '紫', '姿', '滋', '籽', '咨', '兹']],
    ['zong', ['总', '综', '宗', '踪', '纵', '棕']],
    ['zou', ['走', '奏', '揍']],
    ['zu', ['组', '族', '足', '阻', '祖', '租', '卒']],
    ['zuan', ['钻', '纂']],
    ['zui', ['最', '醉', '罪', '嘴']],
    ['zun', ['尊', '遵']],
    ['zuo', ['做', '作', '左', '坐', '座', '昨', '佐', '琢']],
  ]);

  // Common two-character phrases for better prediction
  private static phraseMap: Map<string, string[]> = new Map([
    ['women', ['我们']],
    ['tamen', ['他们']],
    ['nimen', ['你们']],
    ['dajia', ['大家']],
    ['zhongguo', ['中国']],
    ['kexue', ['科学']],
    ['jishu', ['技术']],
    ['fazhan', ['发展']],
    ['jingji', ['经济']],
    ['wenhua', ['文化']],
    ['jiaoyu', ['教育']],
    ['gongzuo', ['工作']],
    ['shenghuo', ['生活']],
    ['xuexi', ['学习']],
    ['yanjiu', ['研究']],
    ['shijian', ['时间', '实践']],
    ['wenjian', ['文件']],
    ['xinxi', ['信息']],
    ['shuju', ['数据']],
    ['xitong', ['系统']],
    ['huanjing', ['环境']],
    ['guojia', ['国家']],
    ['shehui', ['社会']],
    ['shichang', ['市场']],
    ['fuwu', ['服务']],
    ['guanli', ['管理']],
    ['jianshe', ['建设']],
    ['wenti', ['问题']],
    ['fangfa', ['方法']],
    ['zuoyong', ['作用']],
    ['zhuyi', ['注意', '主意']],
    ['biaozhun', ['标准']],
    ['jiben', ['基本']],
    ['zhongyao', ['重要']],
    ['xuyao', ['需要']],
    ['yiding', ['一定']],
    ['keneng', ['可能']],
    ['yinggai', ['应该']],
    ['xianzai', ['现在']],
    ['yijing', ['已经']],
    ['meiyou', ['没有']],
    ['kaishi', ['开始']],
    ['jixu', ['继续']],
    ['zhidao', ['知道', '指导']],
    ['shiyong', ['使用']],
    ['jiejue', ['解决']],
    ['tigong', ['提供']],
    ['guanxi', ['关系']],
    ['yiyi', ['意义', '一一']],
    ['xiangmu', ['项目']],
    ['chengxu', ['程序']],
    ['sheji', ['设计']],
    ['kaifa', ['开发']],
    ['ceshi', ['测试']],
    ['yunxing', ['运行']],
    ['bufen', ['部分']],
    ['suoyi', ['所以']],
    ['yinwei', ['因为']],
    ['rugu', ['如果']],
    ['raner', ['然而']],
    ['bingqie', ['并且']],
    ['suran', ['虽然']],
    ['danshi', ['但是']],
    ['zheyang', ['这样']],
    ['name', ['那么']],
    ['ruhe', ['如何']],
  ]);

  /**
   * Convert pinyin input to candidate Chinese characters.
   * Supports multi-syllable input with phrase-level prefix matching.
   */
  static getCandidates(pinyin: string): string[] {
    if (!pinyin || pinyin.length === 0) {
      return [];
    }

    const lower = pinyin.toLowerCase().trim();
    let results: string[] = [];

    // 1. Exact phrase match (e.g., "women" → "我们")
    const phraseCandidates = PinyinEngine.phraseMap.get(lower);
    if (phraseCandidates) {
      results = results.concat(phraseCandidates);
    }

    // 2. Exact single-syllable match (e.g., "ni" → "你")
    const charCandidates = PinyinEngine.pinyinDict.get(lower);
    if (charCandidates) {
      results = results.concat(charCandidates);
    }

    // 3. Phrase prefix matching (e.g., "wom" → "我们")
    if (results.length < 10) {
      for (const key of PinyinEngine.phraseMap.keys()) {
        if (key.startsWith(lower) && key !== lower) {
          const phrases: string[] | undefined = PinyinEngine.phraseMap.get(key);
          if (phrases) {
            results = results.concat(phrases);
            if (results.length >= 5) {
              break;
            }
          }
        }
      }
    }

    // 4. Multi-syllable segmentation → combine into phrases
    //    Complete+complete: "nihao" → "ni"+"hao" → "你好", "你号"
    //    Complete+partial:  "nih"   → "ni"+"h"   → "你好", "你还"
    if (results.length < 10 && lower.length >= 3) {
      const combos = PinyinEngine.buildPhraseCombos(lower);
      results = results.concat(combos);
    }

    // 5. Longest valid syllable prefix → single-char candidates
    //    (e.g., "nih" → "ni" is valid → "你", "尼")
    if (results.length < 10) {
      for (let i = lower.length; i > 0; i--) {
        const prefix = lower.substring(0, i);
        const chars = PinyinEngine.pinyinDict.get(prefix);
        if (chars) {
          results = results.concat(chars.slice(0, 3));
          break;
        }
      }
    }

    // 6. Single-character prefix matching for short/partial single syllable
    //    (e.g., "n" → "那", "哪", "拿" from "na")
    if (results.length < 10) {
      for (const key of PinyinEngine.pinyinDict.keys()) {
        if (key.startsWith(lower) && key !== lower) {
          const chars: string[] | undefined = PinyinEngine.pinyinDict.get(key);
          if (chars) {
            results = results.concat(chars.slice(0, 2));
            if (results.length >= 10) {
              break;
            }
          }
        }
      }
    }

    // Deduplicate while preserving priority order
    const seen = new Set<string>();
    const unique: string[] = [];
    for (const r of results) {
      if (!seen.has(r)) {
        seen.add(r);
        unique.push(r);
      }
    }
    return unique.slice(0, 10);
  }

  /**
   * Return all candidates without the 10-item cap, for the dropdown "more" panel.
   * Uses a generous limit (60) to cover most practical scenarios.
   */
  static getAllCandidates(pinyin: string): string[] {
    if (!pinyin || pinyin.length === 0) {
      return [];
    }

    const lower = pinyin.toLowerCase().trim();
    let results: string[] = [];
    const MAX = 60;

    // 1. Exact phrase match
    const phraseCandidates = PinyinEngine.phraseMap.get(lower);
    if (phraseCandidates) {
      results = results.concat(phraseCandidates);
    }

    // 2. Exact single-syllable match
    const charCandidates = PinyinEngine.pinyinDict.get(lower);
    if (charCandidates) {
      results = results.concat(charCandidates);
    }

    // 3. Phrase prefix matching (more generous)
    if (results.length < MAX) {
      for (const key of PinyinEngine.phraseMap.keys()) {
        if (key.startsWith(lower) && key !== lower) {
          const phrases: string[] | undefined = PinyinEngine.phraseMap.get(key);
          if (phrases) {
            results = results.concat(phrases);
            if (results.length >= MAX) {
              break;
            }
          }
        }
      }
    }

    // 4. Multi-syllable segmentation (more combinations)
    if (results.length < MAX && lower.length >= 3) {
      const combos = PinyinEngine.buildPhraseCombosExpanded(lower);
      results = results.concat(combos);
    }

    // 5. Longest valid syllable prefix (more chars)
    if (results.length < MAX) {
      for (let i = lower.length; i > 0; i--) {
        const prefix = lower.substring(0, i);
        const chars = PinyinEngine.pinyinDict.get(prefix);
        if (chars) {
          results = results.concat(chars.slice(0, 6));
          break;
        }
      }
    }

    // 6. Single-character prefix matching (more chars)
    if (results.length < MAX) {
      for (const key of PinyinEngine.pinyinDict.keys()) {
        if (key.startsWith(lower) && key !== lower) {
          const chars: string[] | undefined = PinyinEngine.pinyinDict.get(key);
          if (chars) {
            results = results.concat(chars.slice(0, 4));
            if (results.length >= MAX) {
              break;
            }
          }
        }
      }
    }

    // Deduplicate while preserving priority order
    const seen = new Set<string>();
    const unique: string[] = [];
    for (const r of results) {
      if (!seen.has(r)) {
        seen.add(r);
        unique.push(r);
      }
    }
    return unique;
  }

  /**
   * Check whether there are more candidates beyond the default 10 shown in the bar.
   */
  static hasExtraCandidates(pinyin: string): boolean {
    return PinyinEngine.getAllCandidates(pinyin).length > 10;
  }

  /**
   * Greedy split multi-syllable pinyin into valid syllables,
   * then combine characters into phrase candidates.
   *
   * Case A — all complete syllables:
   *   "nihao"  → "ni"+"hao"    → "你好", "你号"
   *   "shijian"→ "shi"+"jian"  → "时间", "实践"
   *   "jisuan" → "ji"+"suan"   → "计算", "几算"
   *
   * Case B — complete + partial last syllable:
   *   "nih"    → "ni"+"h"      → combine "你" × chars matching "h" prefix
   *   "wom"    → "wo"+"m"      → combine "我" × chars matching "m" prefix
   */
  /**
   * Expanded version returning more phrase combos for the dropdown panel.
   */
  private static buildPhraseCombosExpanded(input: string): string[] {
    const results: string[] = [];

    // Case A: all complete syllables → direct character combination
    for (let split = 2; split < input.length; split++) {
      const first = input.substring(0, split);
      const second = input.substring(split);
      const firstChars = PinyinEngine.pinyinDict.get(first);
      const secondChars = second.length <= 6 ? PinyinEngine.pinyinDict.get(second) : undefined;
      if (firstChars && secondChars) {
        for (const fc of firstChars.slice(0, 3)) {
          for (const sc of secondChars.slice(0, 4)) {
            results.push(fc + sc);
            if (results.length >= 16) {
              return results;
            }
          }
        }
        return results;
      }
    }

    // Case B: complete + partial last syllable → prefix character lookup
    for (let split = input.length - 1; split >= 2; split--) {
      const first = input.substring(0, split);
      const rest = input.substring(split);
      const firstChars = PinyinEngine.pinyinDict.get(first);
      if (firstChars) {
        const restChars: string[] = [];
        for (const key of PinyinEngine.pinyinDict.keys()) {
          if (key.startsWith(rest)) {
            const chars = PinyinEngine.pinyinDict.get(key);
            if (chars) {
              restChars.push(chars[0]);
              if (restChars.length >= 10) {
                break;
              }
            }
          }
        }
        if (restChars.length > 0) {
          for (const fc of firstChars.slice(0, 3)) {
            for (const rc of restChars) {
              results.push(fc + rc);
              if (results.length >= 16) {
                return results;
              }
            }
          }
          return results;
        }
      }
    }

    return results;
  }

  private static buildPhraseCombos(input: string): string[] {
    const results: string[] = [];

    // Case A: all complete syllables → direct character combination
    for (let split = 2; split < input.length; split++) {
      const first = input.substring(0, split);
      const second = input.substring(split);
      const firstChars = PinyinEngine.pinyinDict.get(first);
      const secondChars = second.length <= 6 ? PinyinEngine.pinyinDict.get(second) : undefined;
      if (firstChars && secondChars) {
        for (const fc of firstChars.slice(0, 2)) {
          for (const sc of secondChars.slice(0, 3)) {
            results.push(fc + sc);
            if (results.length >= 6) {
              return results;
            }
          }
        }
        return results;
      }
    }

    // Case B: complete + partial last syllable → prefix character lookup
    for (let split = input.length - 1; split >= 2; split--) {
      const first = input.substring(0, split);
      const rest = input.substring(split);
      const firstChars = PinyinEngine.pinyinDict.get(first);
      if (firstChars) {
        // Collect characters whose pinyin starts with the partial tail
        const restChars: string[] = [];
        for (const key of PinyinEngine.pinyinDict.keys()) {
          if (key.startsWith(rest)) {
            const chars = PinyinEngine.pinyinDict.get(key);
            if (chars) {
              restChars.push(chars[0]);
              if (restChars.length >= 5) {
                break;
              }
            }
          }
        }
        if (restChars.length > 0) {
          for (const fc of firstChars.slice(0, 2)) {
            for (const rc of restChars) {
              results.push(fc + rc);
              if (results.length >= 6) {
                return results;
              }
            }
          }
          return results;
        }
      }
    }

    return results;
  }

  /**
   * Check if the input is a valid/partial pinyin syllable.
   */
  static isValidPinyin(pinyin: string): boolean {
    if (!pinyin || pinyin.length === 0) {
      return false;
    }
    const lower = pinyin.toLowerCase().trim();
    if (!/^[a-z]+$/.test(lower)) {
      return false;
    }

    if (PinyinEngine.pinyinDict.has(lower)) {
      return true;
    }

    for (const key of PinyinEngine.pinyinDict.keys()) {
      if (key.startsWith(lower)) {
        return true;
      }
    }

    return false;
  }
}
