//
//  MainViewController.swift
//  Recipes
//
//  Created by Sergey Osipyan on 12/10/18.
//  Copyright © 2018 Lambda Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func textAction(_ sender: Any) {
        resignFirstResponder()
        filterRecipes()
        
    }
    
    let networkClient = RecipesNetworkClient()
    var recipesTableViewController: RecipesTableViewController? {
        didSet {
            recipesTableViewController?.recipes = filteredRecipes
        }
    }
    var filteredRecipes: [Recipe] = [] {
        didSet {
            recipesTableViewController?.recipes = filteredRecipes
        }
    }
    var allRecipe: [Recipe] = [] {
        didSet {
            
            filterRecipes()
        }
        }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkClient.fetchRecipes { (recipes, error) in
        if let error = error {
            NSLog("Error featching Recipes\(error)")
            return
        }
            self.allRecipe = recipes ?? []
    }
    
    }
    
    func filterRecipes() {
        
        DispatchQueue.main.async {
            guard let searchTerm = self.textField.text, !searchTerm.isEmpty else {
            
                self.filteredRecipes = self.allRecipe
            
            return
        }
        
        
            
            self.filteredRecipes = self.allRecipe.filter({ (string) -> Bool in
            
            string.name.lowercased().contains(searchTerm) || string.instructions.lowercased().contains(searchTerm)
        })
                
        
        }
        
    }
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tablecell" {
            recipesTableViewController = segue.destination as? RecipesTableViewController
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    

}
