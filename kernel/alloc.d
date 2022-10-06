module kernel.alloc;

import sys = kernel.sys;
import vm = kernel.vm;

uintptr pagenum(uintptr pa) {
    return pa / sys.pagesize;
}

uintptr pageaddr(uintptr pn) {
    return pn * sys.pagesize;
}

enum min_order = 12;
enum max_order = sys.log_memsize_physical;

struct phys_page_t {
    bool free;
    uint order;
}

struct free_page_t {
    free_page_t* next;
    free_page_t* prev;
}

// Free list for each type of order.
__gshared free_page_t*[max_order + 1] free_lists;

void ll_free_insert(free_page_t* n, int order) {
    n.next = free_lists[order];
    n.prev = null;
    if (free_lists[order])
        free_lists[order].prev = n;
    free_lists[order] = n;
}

void ll_free_remove(free_page_t* n, int order) {
    if (n.next)
        n.next.prev = n.prev;
    if (n.prev)
        n.prev.next = n.next;
    else
        free_lists[order] = n.next;
}

__gshared phys_page_t[sys.memsize_physical / sys.pagesize] pages;

// Checks if a page is valid for a given order.
bool valid(uintptr pn, uint order) {
    return pageaddr(pn) % (1 << order) == 0;
}

// Returns the page number of the buddy of the page stored at pn. Returns -1 if
// the given pn is not valid
uintptr get_buddy(uintptr pn) {
    phys_page_t p = pages[pn];
    if (p.order < min_order || p.order > max_order || !valid(pn, p.order)) {
        return -1;
    }

    size_t pa = pageaddr(pn);
    if (valid(pn, p.order + 1)) {
        return pagenum(pa + (1 << p.order));
    }
    return pagenum(pa - (1 << p.order));
}

free_page_t* pn_to_free(uintptr pn) {
    return cast(free_page_t*) vm.pa2ka(pageaddr(pn));
}

// Initialize everything needed for the allocator.
void init() {
}

// low level allocation API
private void* alloc(size_t sz) {
    return null;
}

private void free(void* ptr) {
}
