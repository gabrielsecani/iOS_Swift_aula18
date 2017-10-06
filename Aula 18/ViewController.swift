//
//  ViewController.swift
//  Aula 18
//
//  Created by Usuário Convidado on 05/10/17.
//  Copyright © 2017 Gabriel Lucas de Toledo Ribeiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var txtPersonagem: UITextField!
    @IBOutlet weak var txtAltura: UITextField!
    @IBOutlet weak var tvFilmes: UITableView!
    
    var arrayfilmes: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var session: URLSession?
    
    @IBAction func btnOk(_ sender: Any) {
        let config = URLSessionConfiguration.default
        
        session = URLSession(configuration: config)
        let url = URL(string: "https://swapi.co/api/people/1/")
        
        let task = session?.dataTask(with: url!, completionHandler: { (data, response, error) in
            //ações que serão efetuadas quando
            //a execução da task se completa
            let texto = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(texto!)
            self.arrayfilmes = self.montarArray(data: data!)
            if let personagem = self.retornarDado(data: data!, chave: "name"){
                if let altura = self.retornarDado(data: data!, chave: "height"){
                    DispatchQueue.main.async {
                        self.txtPersonagem.text = personagem
                        self.txtAltura.text = altura
                        self.tvFilmes.reloadData()
                    }
                }
            }
        })
        //a linha abaixo dispara a execução da task
        task?.resume()
    }
    
    func retornarDado(data: Data, chave: String) -> String? {
        var resposta: String?=nil
        do{
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            if let dado = json[chave] as? String{
                resposta = dado
            }
        }catch let error as NSError{
            return "Falha ao carregar: \(error.localizedDescription)"
        }
        return resposta
    }

    func montarArray(data: Data) -> [String] {
        var resposta:[String]=[]
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            if let filmes = json["films"] as? [String]{
                for filme in filmes{
                    resposta.append(filme)
                }
            }
        }catch let error as NSError{
            print( "Falha ao carregar: \(error.localizedDescription)")
        }
        return resposta
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayfilmes.count
    }
    
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     cell.textLabel?.text = arrayfilmes[indexPath.row]
     return cell
     }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

