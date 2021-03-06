conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
conf_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf_data.set_quoted('VERSION', meson.project_version())
conf_data.set_quoted('PREFIX', get_option('prefix'))
project_config = configure_file(
	input : 'ProjectConfig.vala.in',
	output : 'ProjectConfig.vala',
	configuration : conf_data
)

deps = [
	dependency('granite'),
	dependency('gtk+-3.0'),
	dependency('gdk-3.0'),
	dependency('webkit2gtk-4.0'),
	dependency('glib-2.0'),
	dependency('json-glib-1.0'),
	dependency('gee-0.8'),
	dependency('libsoup-2.4'),
	dependency('sqlite3')
]

if get_option('use_ivy')
	deps += dependency('ivy')
endif

executable(
	meson.project_name(),
	project_config,
	
	'app.vala',

	'data/Game.vala',
	'data/GameSource.vala',

	'data/sources/steam/Steam.vala',
	'data/sources/steam/SteamGame.vala',

	'data/sources/gog/GOG.vala',
	'data/sources/gog/GOGGame.vala',

	'data/sources/humble/Humble.vala',
	'data/sources/humble/HumbleGame.vala',
	
	'data/GamesDB.vala',

	'ui/windows/MainWindow.vala',
	'ui/windows/WebAuthWindow.vala',
	
	'ui/dialogs/SettingsDialog.vala',
	'ui/dialogs/GameInstallDialog.vala',

	'ui/dialogs/GameDetailsDialog.vala',

	'ui/views/BaseView.vala',
	'ui/views/WelcomeView.vala',

	'ui/views/GamesView/GamesView.vala',
	'ui/views/GamesView/GameCard.vala',
	'ui/views/GamesView/GameListRow.vala',
	'ui/views/GamesView/GameDownloadProgressView.vala',

	'ui/views/GameDetailsView/GameDetailsView.vala',

	'ui/widgets/AutoSizeImage.vala',
	'ui/widgets/ActionButton.vala',

	'utils/Utils.vala',
	'utils/FSUtils.vala',
	'utils/Parser.vala',
	'utils/Settings.vala',
	'utils/Downloader.vala',

	icons_gresource,
	css_gresource,

	dependencies: deps,
	install: true
)
