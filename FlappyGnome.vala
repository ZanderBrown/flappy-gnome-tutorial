namespace Flappy { 
    const int WIN_WIDTH = 1280;
    const int WIN_HEIGHT = 720;
    const int GAP_HEIGHT = 180;
    const int PIPE_WIDTH = 80;
    const int SCROLL_SPEED = 5;
    const int JUMP_HEIGHT = 20;
    const int GROUND_HEIGHT = 100;

    const string SCORE_TEMPLATE = "Score: <b>%u</b>";

    private enum GameState {
        INIT,
        PLAYING,
        GAME_OVER;
    }

    public class Application : Gtk.Application {
        public Application () {
            Object(
                application_id: "org.gnome.Flappy",
                flags: ApplicationFlags.FLAGS_NONE);
        }

        public override void startup () {
            base.startup();

            string css;
            if (Gtk.check_version (3, 20, 0) == null) {                 // check GTK version
                css = "/org/gnome/Flappy/flappy-3.20.css";              // use new CSS file on >= 3.20
            } else {
                css = "/org/gnome/Flappy/flappy.css";
            }
    
            var css_provider = new Gtk.CssProvider ();                  // Initialize a CSS provider
            css_provider.load_from_resource (css);                      // from the css file in the current directory
    
            Gtk.StyleContext.add_provider_for_screen (                  // use the css provider
                Gdk.Screen.get_default (),                              // on the default screen
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        }

        public override void activate () {
            if (active_window != null) {
                active_window.present();
                return;
            }
            
            var window = new Window (this);
            window.show_all ();                                         // Show the window and each component withing
        }
    }

    int main (string[] args) {
        Environment.set_prgname("org.gnome.Flappy");
        Environment.set_application_name("Flappy");
        return new Application().run(args);
    }
}