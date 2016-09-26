module Gcaldis
  module Display
    require 'gtk3'
    require 'glib2'
    class RubyApp < Gtk::Window
  
      def initialize
        @first_day_of_month=(Date.today-Date.today.mday+1)
        @calendar_start=@first_day_of_month-@first_day_of_month.wday
          super
          set_name('MyWindow')
          set_title "Andy's Calendar - #{Date::MONTHNAMES[Date.today.month]} #{Date.today.year}"
          
          signal_connect "destroy" do 
              Gtk.main_quit 
          end
          
          init_ui
          
          set_default_size 1800, 1040
          set_window_position(:center)
          
          show_all
          provider=simple_css
          apply_css self, provider
      end
      
      def apply_css(widget, provider)
        widget.style_context.add_provider(provider, GLib::MAXUINT)
        if widget.is_a?(Gtk::Container)
          widget.each_all do |child|
            apply_css(child, provider)
          end
        end
      end
      
      def simple_css
        # adding simple css
        css = <<-EOT
                #MyWindow {
                background-color: #CCCCCC;
                 }
                GtkBox {
                  background-color: #CCFFFF;
                }
                GtkLabel {
                  background-color: #FFDDDD;
                }
          EOT
          css_provider=Gtk::CssProvider.new
          css_provider.load :data=>css
          style_context=Gtk::StyleContext.new

          style_context.add_provider(css_provider, 100000)
          return css_provider
      end
      
      
      def init_ui

        grid = Gtk::Grid.new 
        grid.set_name 'MyGrid'
        grid.set_row_spacing 2
        grid.set_column_spacing 2
        grid.expand=true
        
        frame = Gtk::Frame.new
        frame.set_hexpand true
        frame.set_vexpand true
        grid.attach frame, 0, 1, 7, 5
          
        days=['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
        
        days.each_with_index do |d,i|
          grid.attach Gtk::Label.new(d), i,0,1,1
        end
        
        box=[]

        
        0.upto 34 do |i|
          left=(i % 7)
          top=i.div(7)+1
          puts "#{left},#{top}"
          box[i] = Gtk::Box.new(Gtk::Orientation::VERTICAL)
          box[i].pack_start(Gtk::Label.new((@calendar_start+i).mday.to_s), :expand => false, :fill => true, :padding => 4)
          
          grid.attach box[i], left, top, 1, 1
        end


        label0a = Gtk::Label.new('Label 0a')
        label0b = Gtk::Label.new('Label 0b')
        label0c = Gtk::Label.new('Label 0c')
        label7a = Gtk::Label.new('Label 7a')
        label7b = Gtk::Label.new('Label 7b')
        label7c = Gtk::Label.new('Label 7c')
        label7d = Gtk::Label.new('Label 7d')
        label7e = Gtk::Label.new('Label 7e this is quite a long and biggish appointment description')

        

        
        box[0].pack_start(label0a, :expand => false, :fill => false, :padding => 4)
        box[0].pack_start(label0b, :expand => false, :fill => false, :padding => 4)
        box[0].pack_start(label0c, :expand => false, :fill => false, :padding => 4)
        box[7].pack_start(label7a, :expand => false, :fill => false, :padding => 4)
        box[7].pack_start(label7b, :expand => false, :fill => false, :padding => 4)
        box[7].pack_start(label7c, :expand => false, :fill => false, :padding => 4)
        box[7].pack_start(label7d, :expand => false, :fill => false, :padding => 4)
        box[7].pack_start(label7e, :expand => false, :fill => false, :padding => 4)

        add grid
      end

      

    end
    
    def self.run_gtk
      window = RubyApp.new
      # this is how to do a periodic call, eg 1second
      #GLib::Timeout.add(1000) do
      #  puts 'heh'
      #  true
      #end
      Gtk.main
    end
    

  end
end
