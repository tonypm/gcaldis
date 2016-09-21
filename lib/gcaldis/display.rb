module Gcaldis
  module Display
    require 'gtk3'
    require 'glib2'
    class RubyApp < Gtk::Window
  
      def initialize
          super
          set_name('MyWindow')
          set_title "Messages"
          
          signal_connect "destroy" do 
              Gtk.main_quit 
          end
          
          
          init_ui
          
          
          
          set_default_size 500, 300
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
                #MyLabel {
                  background-color: #00FF00;
                  border-style: solid;
                  border-width: 4px;
                  border-color: #fff;
                  
                }
                #MyWindow {
                background-color: #FF0000;
                 }
                GtkLabel {
                  background-color: #0000FF;
                }
          EOT
          css_provider=Gtk::CssProvider.new
          css_provider.load :data=>css
          style_context=Gtk::StyleContext.new

          style_context.add_provider(css_provider, 100000)
          return css_provider
      end
      
      
      def init_ui
      
          table = Gtk::Table.new 2, 2, true
          
          info = Gtk::Label.new("Information")
          ques = Gtk::Button.new(:label => "Question")
          grid = Gtk::Grid.new
          

  

          
          ques.signal_connect "clicked" do
              on_ques
          end
          
          table.attach info, 0, 1, 0, 1
          table.attach grid, 1, 2, 0, 2
          table.attach ques, 0, 1, 1, 2
          #table.attach erro, 1, 2, 1, 2
          
          
          grid_attach(grid)
          grid.set_row_spacing 10
          
          add table

          
      end
      
 
      def grid_add(grid)
        child1=Gtk::Label.new("First Child")
        grid.add child1
        child2=Gtk::Label.new("Second Child")
        grid.add child2
      end
      
      def grid_attach(grid)
        child1=Gtk::Label.new("First Child")
        child1.set_name "MyLabel"
        grid.attach child1, 0,0,1,1
        child2=Gtk::Label.new("Second Child")
        grid.attach child2, 0,1,1,1
      end
      
      
      def on_ques
          # deprecated -> Gtk::MessageDialog::QUESTION, you should use :question
          md = Gtk::MessageDialog.new(:parent => self, :flags => :destroy_with_parent,
                                      :type => :question, :buttons_type => :close,
                                      :message => "Are you sure to quit?")
          md.run
          md.destroy
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
