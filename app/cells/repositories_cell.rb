class RepositoriesCell < Cell::Rails

  def new_link
    render
  end

  def latest_with_category_jiao_yu_zi_yuan
    find_category_and_repositories("jiao-yu-zi-yuan")
    render :view => "latest_with_category.html.haml"
  end

  def latest_with_category_jing_ji_guan_li
    find_category_and_repositories("jing-ji-guan-li")
    render :view => "latest_with_category.html.haml"
  end

  def latest_with_category_yu_le_sheng_huo
    find_category_and_repositories("yu-le-sheng-huo")
    render :view => "latest_with_category.html.haml"
  end

  def latest_with_category_itzi_liao
    find_category_and_repositories("itzi-liao")
    render :view => "latest_with_category.html.haml"
  end

  def latest_with_category_zhuan_ye_zi_liao
    find_category_and_repositories("zhuan-ye-zi-liao")
    render :view => "latest_with_category.html.haml"
  end

  def latest_with_category_you_xi_zi_liao
    find_category_and_repositories("you-xi-zi-liao")
    render :view => "latest_with_category.html.haml"
  end

  def latest_with_category_ban_gong_wen_shu
    find_category_and_repositories("ban-gong-wen-shu")
    render :view => "latest_with_category.html.haml"
  end

  def hot_tags
    @tags = Repository.tag_counts_on(:tags).limit(30).order(["count desc"])
    render
  end

  private
    def find_category_and_repositories(category_code_name)
      @category = Category.find_by_code!(category_code_name)
      @repositories = Repository.with_category(@category).limit(6)
    end

end
