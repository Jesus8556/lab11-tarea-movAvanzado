//
//  ViewController.swift
//  GoogleGutierrez
//
//  Created by Luis Gutierrez on 12/11/23.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {
    @Published var isLoginSuccesed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func iniciarSesion(_ sender: Any) {
        signWithGoogle()
    }
    
    
    func signWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let self = self else { return }
          guard error == nil else {
              print("cancelar sesión con Google")
              return
            
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              print("No se pudo obtener la información del usuario.")
              return
            // ...
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                            // Manejar el error al intentar iniciar sesión en Firebase.
                            print("Error al iniciar sesión en Firebase con Google: \(error.localizedDescription)")
                            return
                        }

                        // Si no hay errores, el usuario ha iniciado sesión correctamente en Firebase.
                        print("Inicio de sesión exitoso en Firebase con Google.")

              // At this point, our user is signed in
            }
                

          // ...
        }
    }


}

