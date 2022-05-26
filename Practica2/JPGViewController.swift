//
//  JPGViewController.swift
//  Practica2
//
//  Created by Yu on 25/05/22.
//

import UIKit
import WebKit
import Network

class JPGViewController: UIViewController {

 
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imageView: UIImageView!
    var a_i = UIActivityIndicatorView()
    var internetStatus = false
  
    func internet(){
        let monitor = NWPathMonitor() //Es un closure, se ejecuta de manera aisncrona y es como una funcion anonima
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied{
                self.internetStatus = false
            }else {
                self.internetStatus = true
            }
            
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        internet()
        
    }
    
   
    
    func activityIndicator(){
        a_i.style = .large
               a_i.color = .red
               a_i.hidesWhenStopped = true
               a_i.center = self.view.center
               self.view.addSubview(a_i)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nameFile = "geo_vertical.jpg"
        
        if cargaImagenLocal(nameFile) == false {
            if internetStatus {
                if let url = URL(string: DataManager.instance.baseURL + nameFile){
                let request = URLRequest(url: url)
                            let sesion = URLSession.shared
                            let tarea = sesion.dataTask(with: request) { bytes, response, error in
                                if error != nil {
                                    print ("ocurrio un error \(error!.localizedDescription)")
                                }
                                else {
                                    let image = UIImage(data: bytes!)
                                    self.guardaImagen(bytes!, nameFile)
                                        DispatchQueue.main.async {
                                            self.imageView.image = image
                                            self.a_i.stopAnimating()
                                        }
                                }
                            }
                            a_i.startAnimating()
                            tarea.resume()
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "No hay conexion a internet", preferredStyle: .alert)
                let boton = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(boton)
                self.present(alert, animated: true)
            }
        }
    }
    
    func cargaImagenLocal (_ nombre: String) -> Bool {
        // 1. Obtener la ruta a documents
        let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        // 2. comprobar si existe el archivo
        // 2.a. el objeto URL tiene una propiedad path....
        //print(urlAlArchivo.path)
        if FileManager.default.fileExists(atPath: urlAlArchivo.path){
            // 3. si el archivo existe, lo cargamos en el imageview y se regresa true
                do {
                    let bytes = try Data(contentsOf: urlAlArchivo)
                    let image = UIImage(data: bytes)
                    self.imageView.image = image
                    print("carga local")
                } catch {
                    print("Ocurrio un error \(error.localizedDescription)")
                }
            return true
        }else{
            // 4. si el archivo no existe se regresa false.
            return false
        }
    }
    
    func guardaImagen(_ bytes:Data, _ nombre:String) {
            // 1. Obtenemos la ubicacion de la carpeta de documents
            let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
            do {
                try bytes.write(to: urlAlArchivo)
                print("descarga de intenert")
            }
            catch {
                print ("no se puede salvar la imagen \(error.localizedDescription)")
            }
        }
    
  
       
}
   
