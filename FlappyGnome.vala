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
            var window = new Gtk.Window ();                             // Set up a window
            window.window_position = Gtk.WindowPosition.CENTER;         // centered on the screen
            window.title = "FlappyGnome";                               // proudly displaying the application name in the titlebar
            window.set_size_request (WIN_WIDTH, WIN_HEIGHT);            // with an appropriate size requested
            window.resizable = false;                                   // as we don't want to deal with dynamic resizing for now
    
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);        // add a box representing the content area
    
            var scrolled_window = new Gtk.ScrolledWindow (null, null);  // Add a scrollable area
            scrolled_window.set_policy (Gtk.PolicyType.ALWAYS,          // always show the horizontal scrollbar
                                        Gtk.PolicyType.NEVER);          // but never show the vertical one
            scrolled_window.expand = true;                              // use all available space for this component
            scrolled_window.set_placement (Gtk.CornerType.BOTTOM_LEFT); // move the scrollable content below the horizontal scrollbar
    
            var ground = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);   // static component without scrolling
            ground.set_size_request (WIN_WIDTH, GROUND_HEIGHT);         // with a fixed size
            ground.get_style_context ().add_class ("ground");           // used as the floor
    
            var restart_button = new Gtk.Button.from_icon_name (        // create a restart button
                                        "view-refresh-symbolic",        // with a refresh icon
                                        Gtk.IconSize.DND);              // with an image 32x32 px
            restart_button.set_size_request (64, 64);
            ground.pack_start (restart_button, false, false, 0);        // add the restart button to the bottom left corner
            restart_button.margin = 20;                                 // add a margin to avoid the restart button expanding to the window border
            restart_button.can_focus = false;                           // disable can_focus to avoid stealing space keypress after clicked
    
            var score_label = new Gtk.Label ("");                       // create a score widget
            ground.pack_end (score_label, false, false, 0);             // pack it in the bottom right corner
            score_label.margin = 20;                                    // add a margin to avoid the score label expanding to the window border
    
            box.add (scrolled_window);                                  // add the scrolled area to the content area
            box.add (ground);                                           // add the floor to the content area
            window.add (box);                                           // and add the content container to the main window
    
            var game_area = new GameArea ();                            // Add the game area
            scrolled_window.add (game_area);                            // to the scrollable to support scrolling, as we are doing a side-scroller
    
            game_area.score_changed.connect ( (score) => {              // connect to the score changed signal
                score_label.set_markup (SCORE_TEMPLATE.printf (score)); // and update the score label on each change
            });
    
            restart_button.clicked.connect ((event) => {                // connect to the restart button clicked signal
                game_area.setup_new_game ();                            // to start a new game
            });
            game_area.setup_new_game ();                                // setup a new game
            window.show_all ();                                         // Show the window and each component withing

            add_window(window);
        }
    }

    int main (string[] args) {
        Environment.set_prgname("org.gnome.Flappy");
        Environment.set_application_name("Flappy");
        return new Application().run(args);
    }
}