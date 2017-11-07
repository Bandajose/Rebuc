//
//  UniverCrearTicketsViewController.swift
//  ReBUC PRBSoft
//
//  Created by 7k on 31/10/17.
//  Copyright © 2017 7k. All rights reserved.
//

import UIKit
import SQLite

class UniverCrearTicketsViewController: UIViewController {
    
    // Objeto que se ....
    
    @IBOutlet var consultaTextField:UITextField!
    // Tabla de sesion activa
    var database: Connection!
    let sesionTabla = Table("sesion")
    let idUsuarioSesExp = Expression<Int>("id_usuario")
    //table de tickets
    
    let ticketsTabla = Table("Tickets")
    let idTicketExp = Expression<Int>("id_ticket")
    let idUsuarioExp = Expression<Int>("id_usuario")
    let idUsuariosBibliotecarioExp = Expression<Int>("id_usuario_bibliotecario")
    let fechaTicketExp = Expression<String>("fecha_ticket")
    let consultaExp = Expression<String>("consulta")
    let estatusExp = Expression<String>("estatus")
    let calificacionExp = Expression<Int>("calificacion")
    
    //variables a utilizar
    
    var idUsuario : Int!
    var fechaActual : String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Obtener ruta del archivo
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("usuarios").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }catch {
            print(error)
        }
        
        
        
    }
    
    // Crear
    
    @IBAction func crearTicket(_ sender: UIButton){
        //obtener id usuario que inicio sesion
        do{
            let usuarios = try self.database.prepare(self.sesionTabla)
            for usuario in usuarios{
                self.idUsuario = usuario[self.idUsuarioSesExp]
                print("el id del usuario es: \(self.idUsuario)")
                
            }
            
        }catch{
            print(error)
        }
        
        // crear la tabla de ticktes
        let crearTabla = self.ticketsTabla.create{(tabla) in
            tabla.column(self.idTicketExp,primaryKey:true)
            tabla.column(self.idUsuarioExp)
            tabla.column(self.idUsuariosBibliotecarioExp)
            tabla.column(self.fechaTicketExp)
            tabla.column(self.consultaExp)
            tabla.column(self.estatusExp)
            tabla.column(self.calificacionExp)

        }
        do{
            try self.database.run(crearTabla)
            print("Tabla de tickets creada")
        }catch{
            print(error)
        }
        
        //Obtener fecha actual
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        fechaActual = formatter.string(from: date)
        
        //Guardar el ticket
        
        let registrarTicket = self.ticketsTabla.insert(self.idUsuarioExp <- self.idUsuario!,self.fechaTicketExp <- self.fechaActual!,consultaExp <- self.consultaTextField.text!,estatusExp <- "Nuevo",calificacionExp <- 0,self.idUsuariosBibliotecarioExp <- 0)
        do{
            try self.database.run(registrarTicket)
            print("Ticket registrado con fecha \(self.fechaActual!) y comentario \(self.consultaTextField.text!) del usuario \(self.idUsuario!)")
            //ejecutar un alert
            let alert = UIAlertController(title: "Exito", message: "Ticket Guardado Correctamente", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default){(_) in }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            //reiniciar textfield
            
            self.consultaTextField.text = ""
            
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
