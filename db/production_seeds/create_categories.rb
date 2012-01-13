#encoding: utf-8

categories = {
  "教育资源" => %w(考试资源 小学初中 高中教育 高等教育 外语学习 学术研究 其他教育资料),
  "经济管理" => %w(战略管理 市场营销 企业制度 行业分析 人力资源 生产运营 财会税务 项目管理 
                经济金融 专利),
  "娱乐生活" => %w(电子书籍  生活百科  爆笑  图片),
  "IT资料" => %w(常用软件 电子通讯 软件工程 解决方案 专题技术 手机软件 源代码 IT书籍 硬件技术 
                电信技术 IT行业分析),
  "专业资料" => %w(贸易 服务 农业 医药 体育 法律 环境 宗教 心理学 基础科学 广告媒体 军事政治 
                矿业冶金 交通运输 水利电力 畜牧养殖 艺术戏曲 地理考古 民族社会 语言、文化 机械、化工 
                教育、出版 哲学、历史 工程建筑、房产),
  "游戏资料" => %w(游戏下载 单机游戏 剑侠世界 征途 赤壁 问道 诛仙 巨人 口袋西游 魔力宝贝Ⅱ 侠义道 
                蜀山OL 西游Q记 封神榜Ⅱ),
  "办公文书" => %w(企业文书 个人文书 文档模板 演讲稿 求职简历)
}

categories.each do |parent_category_name, children_category_names|
  puts "create #{parent_category_name} parent_category..."
  parent_category = Category.find_or_initialize_by_name(parent_category_name.to_s, :code => parent_category_name.to_url)
  parent_category.save!
  children_category_names.each do |child_category_name|
    puts "create #{child_category_name} child_category..."
    child_category = Category.find_or_initialize_by_name(child_category_name.to_s, :code => child_category_name.to_url)
    child_category.parent = parent_category
    child_category.save!
  end
end