//
//  BibliotecarioVerTicketsViewController.swift
//  ReBUC PRBSoft
//
//  Created by 7k on 09/11/17.
//  Copyright © 2017 7k. All rights reserved.
//

import UIKit
import SQLite

class BibliotecarioVerTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
