class PagesController < HighVoltage::PagesController

  layout :layout_for_page

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  

  private

    def layout_for_page
      case params[:id]
      when ""
        ''
      else
        'application'
      end
    end

end
