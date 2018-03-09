namespace Flappy {
	[GtkTemplate (ui = "/org/gnome/Flappy/window.ui")]
	class Window : Gtk.ApplicationWindow {
		[GtkChild]
		Gtk.Box ground;

		[GtkChild]
		Gtk.Label score_label;

		[GtkChild]
		GameArea game_area;

		construct {
            window_position = Gtk.WindowPosition.CENTER;         // centered on the screen
            title = "FlappyGnome";                               // proudly displaying the application name in the titlebar
            set_size_request (WIN_WIDTH, WIN_HEIGHT);            // with an appropriate size requested
            resizable = false;                                   // as we don't want to deal with dynamic resizing for now
		}

		public Window (Application app) {
			Object(application: app);

            ground.set_size_request (WIN_WIDTH, GROUND_HEIGHT);         // with a fixed size
    
            game_area.setup_new_game ();                                // setup a new game
		}

		[GtkCallback]
		private void restart () {
			game_area.setup_new_game ();	                            // to start a new game
		}

		[GtkCallback]
		private void update_score () {
			score_label.set_markup (SCORE_TEMPLATE.printf (game_area.score)); // and update the score label on each change
		}
	}
}
