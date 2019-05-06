const adjust = document.querySelector('#album')

if (adjust){
    fetch('/images')
    .then(res => res.json())
    .then(res => {
        res.forEach(function(iteration) {
            const img = document.createElement('img')
            img.src = iteration

            adjust.appendChild(img)
        })
    })
}
