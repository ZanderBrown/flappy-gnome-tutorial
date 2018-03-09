project('FlappyGnome', ['vala', 'c'], version: '2.0.0')

min_glib_version = '2.44'

glib_dep = dependency('glib-2.0', version: '>=' + min_glib_version)
gtk_dep  = dependency('gtk+-3.0')
rsvg_dep = dependency('librsvg-2.0')
deps = [glib_dep, gtk_dep, rsvg_dep]

gnome = import('gnome')

resources = gnome.compile_resources(
  'flappy_gnome_resources',
  'org.gnome.Flappy.gresource.xml',
)

executable(
  'flappy-gnome',
  ['FlappyGnome.vala', 'gamearea.vala', 'window.vala'],
  resources,
  dependencies: deps,
  install: true
)
