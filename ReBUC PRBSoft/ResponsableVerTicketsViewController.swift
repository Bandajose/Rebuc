//
//  ResponsableVerTicketsViewController.swift
//  ReBUC PRBSoft
//
//  Created by 7k on 14/11/17.
//  Copyright © 2017 7k. All rights reserved.
//

import UIKit
import SQLite

class ResponsableVerTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var ticketsTableView:UITableView!
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
    var idTicket : Int!
    var descripcion: String!
    var estatusTicket : String!
    var idTickets = [Int]()
    var consultas = [String]()
    var estatus = [String]()
    var idBibliotecarios = [Int]()
    var idBibliotecario: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("usuarios").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }catch {
            print(error)
        }
        
        do{
            let usuarios = try self.database.prepare(self.sesionTabla)
            for usuario in usuarios{
                self.idUsuario = usuario[self.idUsuarioSesExp]
                print("el id del usuario es: \(self.idUsuario!)")
                
            }
            
        }catch{
            print(error)
        }
        
        //obtener los datos de cada ticket y guardarlos en arreglos
        
        do{
            for ticket in try database.prepare(self.ticketsTabla){
                self.idTickets.append(ticket[self.idTicketExp])
                self.consultas.append(ticket[self.consultaExp])
                self.estatus.append(ticket[self.estatusExp])
                self.idBibliotecarios.append(ticket[idUsuariosBibliotecarioExp])
            }
        } catch {
            print(error)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //#warning incomplete implementation return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ////#warning incomplete implementation return the number of rows
        return idTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = consultas[indexPath.row]
        cell.detailTextLabel?.text = estatus[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Seleccionaste el ticket numero \(idTickets[indexPath.row])")
        self.idTicket = idTickets[indexPath.row]
        self.descripcion = consultas[indexPath.row]
        self.estatusTicket = estatus[indexPath.row]
        self.idBibliotecario = idBibliotecarios[indexPath.row]
        self.performSegue(withIdentifier: "responsableTicketSegue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Reiniciar datos
        idTickets.removeAll()
        consultas.removeAll()
        estatus.removeAll()
        idBibliotecarios.removeAll()
        
        //obtener los datos de cada ticket y guardarlos en arreglos
        
        do {
            for ticket in try database.prepare(self.ticketsTabla){
                self.idTickets.append(ticket[self.idTicketExp])
                self.consultas.append(ticket[self.consultaExp])
                self.estatus.append(ticket[self.estatusExp])
                self.idBibliotecarios.append(ticket[idUsuariosBibliotecarioExp])

            }
            
        }catch {
            print(error)
        }
        
        //recargar tabla
        ticketsTableView.reloadData()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "responsableTicketSegue" {
            let vc : ResponsableResponderTicketViewController = segue.destination as! ResponsableResponderTicketViewController
            vc.idUsuario = self.idUsuario
            vc.idTicket = self.idTicket
            vc.descripcion = self.descripcion
            vc.estatus = self.estatusTicket
            vc.idBibliotecario = self.idBibliotecario

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
