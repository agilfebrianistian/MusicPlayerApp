//
//  MusicViewController.swift
//  MusicPlayerApp
//
//  Created by Agil Febrianistian on 20/03/25.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView


class MusicViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var songSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let viewModel = MusicViewModel()
    let refreshControl = UIRefreshControl()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0,
                                                                      y: 0,
                                                                      width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height),
                                                        type: .lineScalePulseOutRapid,color: #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(forCell: SongCell.self)
        tableView.registerNib(forCell: EmptyCell.self)
        self.tableView.keyboardDismissMode = .onDrag
        
        activityIndicatorView.padding = 250
        activityIndicatorView.backgroundColor = .gray.withAlphaComponent(0.3)
        self.view.addSubview(activityIndicatorView)

        refreshControl.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // Handle data update
        viewModel.onDataUpdated = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.activityIndicatorView.stopAnimating()
            self?.tableView.reloadData()
            self?.playButton.setImage(self?.viewModel.isPaused ?? false ? UIImage(systemName: "play.fill") : UIImage(systemName: "pause.fill"), for: .normal)
        }
        
        // Handle alert messages
        viewModel.onShowAlert = { [weak self] error in
            self?.refreshControl.endRefreshing()
            self?.activityIndicatorView.stopAnimating()
            self?.showAlert(title: "", message: error.errorMessage ?? "")
        }

        // Handle slider progress
        viewModel.onProgressUpdate = { [weak self] progress in
            DispatchQueue.main.async {
                self?.songSlider.value = progress
            }
        }
        
        reloadData()
    }
    
    @objc func reloadData(){
        activityIndicatorView.startAnimating()
        viewModel.fetchSongList(param: SongParameter(term: searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""))
    }
}

extension MusicViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.song?.results?.count == 0 {
            return 1
        }
        return viewModel.song?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.song?.results?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyCell
            if searchBar.text != "" {
                cell.warningMessageLabel.text = "No results found for \"\(searchBar.text!)\""
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
        
        cell.songNameLabel.text = viewModel.song?.results?[indexPath.row].artistName
        cell.artistNameLabel.text = viewModel.song?.results?[indexPath.row].trackName
        cell.albumNameLabel.text = viewModel.song?.results?[indexPath.row].collectionName
        
        if let url = URL(string: viewModel.song?.results?[indexPath.row].artworkUrl100 ?? ""){
            cell.coverImage.sd_setImage(with: url, completed: nil)
        }
        
        if let isPlaying = viewModel.song?.results?[indexPath.row].isPlaying {
            if isPlaying {
                cell.musicAnimation.isHidden = false
            } else {
                cell.musicAnimation.isHidden = true
            }
        } else {
            cell.musicAnimation.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.playOrPauseSong(at: indexPath.row)
        tableView.reloadData()
    }
}

extension MusicViewController {
    @IBAction func previousButtonTapped(_ sender: Any) {
        viewModel.playPrevious()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        viewModel.isPaused ? viewModel.resumeSong() : viewModel.pauseSong()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        viewModel.playNext()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider){
        viewModel.seekTo(position: sender.value)
    }
}

extension MusicViewController :UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.reloadData()
        }
    }
}
