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
        #grid.column_homogeneous=true
        grid.expand=true
        
        frame = Gtk::Frame.new
        frame.set_hexpand true
        frame.set_vexpand true
        grid.attach frame, 0, 0, 7, 4
          
        table = Gtk::Table.new 2, 2, true
        
        #box1 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
        #box28 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
        
        box=[]
        0.upto 27 do |i|
          box[i] = Gtk::Box.new(Gtk::Orientation::VERTICAL)
          grid.attach box[i], i.div(4), i % 4,1,1
        end


        label0 = Gtk::Label.new('Label 1')
        label27 = Gtk::Label.new('Label 2')
        
        #grid.attach label1, 0,0,1,1
        box[0].pack_start(label0, :expand => true, :fill => true, :padding => 0)
        box[27].pack_start(label27, :expand => true, :fill => true, :padding => 0)

        #table.attach label1, 0, 1, 0, 1

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
