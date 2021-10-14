
# GitHub User

Esta aplicação recebe e trata informação de users de uma API Externa

## Desenvolvimento

1. Aplicação desenvolvida em Swift 
2. Arquitectura MVVM
3. Api Externa Usada (https://api.github.com/users)

## WebServives

 - ServiceManeger: Responsavel pela comunicação com a API Externa 

## Model

 - UserObject 
 - InfoUserObject

## View

- SearchScreenViewController:  Primeiro Ecra. Mostra todos os users do gitHub numa tableView. Quando um user é selecionado em uma celula, o UserDetailsViewController é apresentado. 
- UserDetailsViewController: Mostra mais informação sobre o user. 

## ViewModel

- SearchScreenViewModel
- UserDetailsViewModel

## Custom UI

- ListUserTableViewCell
- UserDetailsTableViewCell


## TODO List

- [x] Fetch User from API
- [x] Show User information
- [ ] Pagination
- [ ] Search User by ID
- [ ] Search User by Name
- [ ] Add app icon
- [ ] Set app launch screen
- [ ] Swipe between User details (previous and next)
- [ ] Improve readme.md with app architecture


