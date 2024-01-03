//
//  SceneDelegate.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        setupRootViewControllerOnFirstLaunch(scene)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

//MARK: - 앱 초기 화면 설정 
extension SceneDelegate {
    private func setupRootViewControllerOnFirstLaunch(_ scene: UIScene){
        if Storage.isFirstTime() {
            setRootViewController(scene, name: "Onboarding",
                                  identifier: "OnboardingViewController")
        } else {
            
            //액세스 토큰으로 로그인 가능한지 확인
            checkAccessTokenLogin { result in
                if result {
                    self.setRootViewController(scene, name: "Diary",
                                          identifier: "DiaryViewController")
                } else {
                    self.setRootViewController(scene, name: "Login",
                                          identifier: "LoginFirstViewController")
                }
            }
        }
        
        
    }
    
    // 초기 루트 뷰 설정을 위한 메서드
    private func setRootViewController(_ scene: UIScene, name: String, identifier: String) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let storyboard = UIStoryboard(name: name, bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
            
            window.rootViewController = viewController
            self.window = window
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            
        }
    }
    
    
    // 뷰컨을 직접 받아서 루트 뷰를 교체하는 메서드 ❗️현재 회원가입 완료 후 해당 메서드로 뷰 변경
    func changeRootViewController(_ vc:UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc // 전환
        
        UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
    
    // 액세스 토큰이 유효하면 true 리턴, 아니면 false 리턴
    private func checkAccessTokenLogin(completion: @escaping (Bool) -> Void) {
        LoginAPI.shared.getAccessTokenLogin { result in
            switch result {
            case .success(let response):
                if response.code == "0000" {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
        }
    }
    
    
}

