using Gtk;
using Granite;

namespace GameHub.Utils
{
	public delegate void Future();
	public delegate void FutureBoolean(bool result);
	public delegate void FutureResult<T>(T result);
	
	public static void open_uri(string uri, Window? parent = null)
	{
		try
		{			
			AppInfo.launch_default_for_uri(uri, null);
		}
		catch(Error e)
		{
			warning(e.message);
		}
	}
	
	public static string run(string cmd)
	{
		string stdout;
		try
		{
			Process.spawn_command_line_sync(cmd, out stdout);
		}
		catch (Error e)
		{
			warning(e.message);
		}
		return stdout;
	}
	
	public static async int run_async(string cmd, bool wait=true)
	{
		int result = -1;
		var c = new Granite.Services.SimpleCommand(Environment.get_home_dir(), cmd);
		c.done.connect(code => {
			result = code;
			Idle.add(run_async.callback);
		});
		c.run();
		if(wait) yield;
		return result;
	}
	
	public static bool is_package_installed(string package)
	{
		var output = Utils.run("dpkg-query -W -f=${Status} " + package);
		return "install ok installed" in output;
	}
	
	public static async void sleep_async(uint interval, int priority = GLib.Priority.DEFAULT)
	{
		Timeout.add(interval, () => {
			sleep_async.callback();
			return false;
		}, priority);
		yield;
	}

	public static async string cache_image(string url, string prefix="remote")
	{
		var parts = url.split("?")[0].split(".");
		var ext = parts.length > 1 ? parts[parts.length - 1] : null;
		ext = ext != null && ext.length <= 6 ? "." + ext : null;
		var hash = Checksum.compute_for_string(ChecksumType.MD5, url, url.length);
		var remote = File.new_for_uri(url);
		var cached = FSUtils.file(FSUtils.Paths.Cache.Images, @"$(prefix)_$(hash)$(ext)");
		try
		{
			if(!cached.query_exists())
			{
				yield Downloader.get_instance().download(remote, { cached.get_path() });
			}
			return cached.get_path();
		}
		catch(IOError.EXISTS e){}
		catch(IOError e)
		{
			warning("Error caching `%s` in `%s`: %s", url, cached.get_path(), e.message);
		}
		return null;
	}

	public static async void load_image(GameHub.UI.Widgets.AutoSizeImage image, string url, string prefix="remote")
	{
		var cached = yield cache_image(url, prefix);
		image.set_source(cached != null ? new Gdk.Pixbuf.from_file(cached) : null);
		image.queue_draw();
	}
}
