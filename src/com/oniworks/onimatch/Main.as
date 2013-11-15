package com.oniworks.onimatch
{
	import com.oniworks.assets.AssetStoreSD;
	import com.oniworks.assets.AssetStoreHD;
	import oni.assets.AssetManager;
	import oni.Startup;
	import oni.utils.Backend;
	import oni.utils.Platform;
	
	/**
	 * ...
	 * @author Sam Hellawell
	 */
	public class Main extends Startup
	{
		
		public function Main() 
		{
			//Set asset stores
			AssetManager.AssetStoreSD = AssetStoreSD;
			AssetManager.AssetStoreHD = AssetStoreHD;
			AssetManager.forceSD = true;
			
			//Set startup class
			Startup.StartupClass = OniMatch;
			
			//Setup backend system
			Backend.init({
				flox: { gameId: "Tewfl9dsQE5SfCne", gameKey: "stJmRx9z7PTea835" }
			});
			
			//Super, because we want to use the default initialiser!
			super(1024, 768);
		}
		
	}

}