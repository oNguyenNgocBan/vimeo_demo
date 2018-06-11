//
//  AppDelegate.swift
//  Vimeo
//
//  Created by Ban Nguyen Ngoc on 4/16/18.
//  Copyright © 2018 ban9ban3. All rights reserved.
//

import UIKit
import VimeoNetworking
import VimeoUpload

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        splitViewController.delegate = self
        let navigationController = splitViewController.viewControllers.last as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem

        VimeoClient.configureSharedClient(withAppConfiguration: AppConfiguration.defaultConfiguration)

        // Starting the authentication process
        let authenticationController = AuthenticationController(client: VimeoClient.sharedClient, appConfiguration: AppConfiguration.defaultConfiguration)

        // First, we try to load a preexisting account

        let loadedAccount: VIMAccount?
        do
        {
            loadedAccount = try authenticationController.loadUserAccount()
        }
        catch let error
        {
            loadedAccount = nil
            print("error loading account \(error)")
        }

        // If we didn't find an account to load or loading failed, we'll authenticate using client credentials

        if loadedAccount == nil
        {
            authenticationController.clientCredentialsGrant { result in

                switch result
                {
                case .success(let account):
                    print("authenticated successfully: \(account)")
                case .failure(let error):
                    print("failure authenticating: \(error)")

                    let title = "Client Credentials Authentication Failed"
                    let message = "Make sure that your client identifier and client secret are set correctly in VimeoClient+Shared.swift"

                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    splitViewController.present(alert, animated: true, completion: nil)
                    print(title + ": " + message)
                }
            }
        }

        return true
    }

    // MARK: - URLs

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    {
        // This handles the redirect URL opened by Vimeo when you complete code grant authentication.
        // If your app isn't opening after you accept permissions on Vimeo, check that your app has the correct URL scheme registered.
        // See the README for more information.

        AuthenticationController(client: VimeoClient.sharedClient, appConfiguration: AppConfiguration.defaultConfiguration).codeGrant(responseURL: url) { result in

            switch result
            {
            case .success(let account):
                print("authenticated successfully: \(account)")
            case .failure(let error):
                print("failure authenticating: \(error)")

                let title = "Code Grant Authentication Failed"
                let message = "Make sure that your redirect URI is added to the dev portal"

                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                print(title + ": " + message)
            }
        }

        return true
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool
    {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }


}

